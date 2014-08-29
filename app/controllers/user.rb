Epistoleiro::App.controllers :user do
  
  before do
    validate_user_access
  end

  post :create_account do
    if User.where(:id => params[:user][:email]).exists?
      put_message :message => 'view.sign_up.message.user_already_registered', :type => 'e'
      return render :signup, :layout => 'public.html'
    elsif User.where(:nickname => params[:user][:nickname]).exists?
      put_message :message => 'view.sign_up.message.nickname_already_in_use', :type => 'e'
      return render :signup, :layout => 'public.html'
    end
      

    @messages = validate_user_account_creation params[:user]
    if @messages.empty?
      user = build_user_account_creation_model(params[:user])
      user.save
      @messages = format_validation_messages user

      if @messages.empty?
        redirect url(:index, :msg => I18n.translate('view.sign_up.message.success').sub('%{email}', user.id), :msg_type => 's')
      else
        put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
        render :signup, :layout => 'public.html'
      end
    else
      put_message :message => @messages.join('<br/>'), :type => 'w'
      raise 'Sending e-mail is not implemented yet' if RACK_ENV == 'production'
      render :signup, :layout => 'public.html'
    end
  end

  get :activation, :map => '/user/activation/:nickname/:activation_key' do
    @user = User.where(:nickname => params[:nickname]).first
    if @user.nil?
      put_message :message => 'view.activation.message.user_does_not_exist', :params => { '%{nickname}' => params[:nickname] }, :type => 'e'
    elsif @user.activation_key != params[:activation_key]
      put_message :message => 'view.activation.message.wrong_activation_key', :type => 'e'
      @user = nil
    elsif @user.active == true
      put_message :message => 'view.activation.message.user_already_active', :type => 'w'
    else
      @user.active = true
      @user.save
      put_message :message => 'view.activation.message.success', :type => 's'
    end

    render :login, :layout => 'public.html'
  end

  post :authentication do
    if user_authenticated? params[:user][:email], params[:user][:password]
      user = User.find(params[:user][:email])
      if user.active == true
        session[:user_id] = user.id
        session[:user_nickname] = user.nickname
        render :dashboard
      else
        put_message :message => 'view.login.message.inactive_user', :type => 'e'
        render :login, :layout => 'public.html'
      end
    else
      put_message :message => 'view.login.message.authentication_error', :type => 'e'
      render :login, :layout => 'public.html'
    end
  end

  get :profile, :map => '/user/:nickname' do
    @signed_user = User.where(:id => session[:user_id]).only(:feature_permissions).first
    @user = User.where(:nickname => params[:nickname]).first
    
    if @user.nil?
      render 'errors/404'
      return
    end
    
    render 'user/profile'
  end

  post :notify_password_change do
    @user = User.where(:id => params[:user][:email]).first
    if @user.nil?
      put_message :message => 'view.forgot_password.message.user_does_not_exist', :params => { '%{email}' => params[:user][:email] }, :type => 'e'
    else
      put_message :message => 'view.forgot_password.message.notify_password_change', :params => { '%{email}' => params[:user][:email] }, :type => 'i'
    end

    render :login, :layout => 'public.html'
  end

  get :reset_password, :map => '/user/:nickname/reset-password/:activation_key' do
    @user = User.where(:nickname => params[:nickname]).first
    if @user.nil?
      put_message :message => 'view.forgot_password.message.invalid_nick_name', :params => { '%{nickname}' => params[:nickname] }, :type => 'e'
    elsif @user.activation_key != params[:activation_key]
      put_message :message => 'view.forgot_password.message.wrong_activation_key', :type => 'e'
    elsif @user.active == false
      put_message :message => 'view.forgot_password.message.inactive_user', :type => 'e'
    else
      raw_password = @user.reset_password
      @user.save!
      raise 'Sending e-mail is not implemented yet' if RACK_ENV == 'production'
      put_message :message => 'view.forgot_password.message.password_reseted', :type => 'i'
    end

    render :login, :layout => 'public.html'
  end

end