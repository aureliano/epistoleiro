Epistoleiro::App.controllers :authentication do

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

  post :create_account do
    unless RACK_ENV == 'test'
      unless recaptcha_valid?
        put_message :message => 'invalid_captcha', :type => 'e'
        return render :signup, :layout => 'public.html'
      end
    end

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
        raise 'Sending e-mail is not implemented yet' if RACK_ENV == 'production'
        session[:msg] = I18n.translate('view.sign_up.message.success').sub('%{email}', user.id)
        session[:msg_type] = 's'

        redirect url :index
      else
        put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
        render :signup, :layout => 'public.html'
      end
    else
      put_message :message => @messages.join('<br/>'), :type => 'w'
      render :signup, :layout => 'public.html'
    end
  end

  post :sign_in do
    if user_authenticated? params[:user][:email], params[:user][:password]
      user = User.find(params[:user][:email])
      if user.active == true
        session[:user_id] = user.id
        session[:user_nickname] = user.nickname
        
        redirect url :index
      else
        put_message :message => 'view.login.message.inactive_user', :type => 'e'
        render :login, :layout => 'public.html'
      end
    else
      put_message :message => 'view.login.message.authentication_error', :type => 'e'
      render :login, :layout => 'public.html'
    end
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
      put_message :message => 'view.forgot_password.message.invalid_nickname', :params => { '%{nickname}' => params[:nickname] }, :type => 'e'
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