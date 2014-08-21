Epistoleiro::App.controllers :user do
  
  before do
    validate_user_access
  end

  post :create_account do
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
      render :signup, :layout => 'public.html'
    end
  end

  get :activation, :map => '/user/activation/:email/:activation_key' do
    @user = User.where(:id => params[:email]).first
    if @user.nil?
      put_message :message => 'view.activation.message.user_does_not_exist', :params => { '%{email}' => params[:email] }, :type => 'e'
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
      render :index
    else
      put_message :message => 'view.login.message.authentication_error', :type => 'e'
      render :login, :layout => 'public.html'
    end
  end

end