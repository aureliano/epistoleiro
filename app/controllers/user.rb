Epistoleiro::App.controllers :user do
  
  before do
    validate_user_access
  end

  get :active_users, :map => '/user/active-users' do
    users = User.where(:active => true, :nickname => { '$regex' => /.*#{params[:query]}.*/, '$options' => 'i' })
      .only(:nickname)
      .collect {|user| user.nickname }
    { :users => users }.to_json
  end

  get :profile, :map => '/user/:nickname' do
    @signed_user = User.where(:id => session[:user_id]).only(:feature_permissions).first
    @user = User.where(:nickname => params[:nickname]).first
    
    return render('errors/404', :layout => false) if @user.nil?
    render 'user/profile'
  end
  
  get :edit_permissions, :map => '/user/:nickname/permissions' do
    @user = User.where(:nickname => params[:nickname]).only(:nickname, :feature_permissions).first
    unless signed_user_has_permission? Rules::USER_MANAGE_PERMISSIONS
      put_message :message => 'view.permissions.message.access_denied', :type => 'e'
      return render 'user/profile'
    end

    render 'user/permissions'
  end
  
  post :update_permissions do
    @user = User.where(:nickname => params[:user][:nickname]).first
    redirect url :index if @user.nil?

    unless signed_user_has_permission? Rules::USER_MANAGE_PERMISSIONS
      put_message :message => 'view.permissions.message.access_denied', :type => 'e'
      return render 'user/profile'
    end

    if params[:user][:features].nil? || params[:user][:features].empty?
      put_message :message => 'view.permissions.message.user_without_any_permission', :type => 'e'
      return render 'user/profile'
    end

    @user.feature_permissions = params[:user][:features].values
    @user.save!

    session[:msg] = I18n.translate('view.permissions.message.update_success')
    session[:msg_type] = 's'
    
    redirect url :user, :profile, :nickname => params[:user][:nickname]
  end

  post :inactivate_user_account do
    manage_user_account_status params[:user][:nickname], false
  end

  post :activate_user_account do
    manage_user_account_status params[:user][:nickname], true
  end

  delete :delete_user_account do
    @user = User.where(:nickname => params[:user][:nickname]).first
    redirect url :index if @user.nil?

    unless signed_user_has_permission? Rules::USER_DELETE_ACCOUNT
      put_message :message => 'view.user_profile.message.user_delete_account.access_denied', :type => 'e'
      return render 'user/profile'
    end

    if session[:user_id] == @user.id
      put_message :message => 'view.user_profile.message.user_delete_account.delete_own_account', :type => 'e'
      return render 'user/profile'
    end

    @user.delete
    session[:msg] = I18n.translate('view.user_profile.message.user_delete_account.success').sub '%{nickname}', @user.nickname
    session[:msg_type] = 's'

    redirect url :index
  end

  get :edit_profile, :map => '/user/:nickname/profile' do
    if (signed_user.nickname != params[:nickname]) && (!signed_user_has_permission? Rules::USER_CREATE_ACCOUNT)
      put_message :message => 'view.user_profile.message.update_profile.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @user = User.where(:nickname => params[:nickname]).first
    redirect url :index if @user.nil?

    @edit_mode = true
    render 'user/profile'
  end

  post :update_profile, :with => :id do
    if (signed_user.id != params[:id]) && (!signed_user_has_permission? Rules::USER_CREATE_ACCOUNT)
      put_message :message => 'view.user_profile.message.update_profile.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @user = User.where(:id => params[:id]).first

    if @user.id != params[:user][:email]
      if User.where(:id => params[:user][:email]).exists?
        put_message :message => 'view.user_profile.message.update_profile.email_already_registered', :type => 'e'
        @edit_mode = true
        return render 'user/profile'
      end
    end

    @user.id = params[:user][:email]
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.home_page = params[:user][:home_page]
    @user.phones = [params[:user][:phone_number]]
    @user.update_tags
    
    unless entity_crud :entity => @user, :action => :save
      @edit_mode = true
      return render 'user/profile'
    end

    session[:msg] = I18n.translate('view.user_profile.message.update_profile.success')
    session[:msg_type] = 's'
    
    redirect url :user, :profile, :nickname => @user.nickname
  end

  get :list_users, :map => '/users' do
    unless signed_user.has_access_to_feature? Features::USER_LIST
      put_message :message => 'view.list_users.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @current_page = 1
    @users = User.all.asc(:nickname).skip(0).limit(DataTable.default_page_size)

    render 'user/list_users'
  end

  post :list_users, :map => '/users' do
    unless signed_user.has_access_to_feature? Features::USER_LIST
      put_message :message => 'view.list_users.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    @current_page = params['dt_users-index'].to_i
    @current_page += 1 if @current_page == 0
    skip = (@current_page - 1) * DataTable.default_page_size
    
    @users = unless params[:query].to_s.empty?
      User.where(:tags => { '$all' => query_to_tags(params[:query]) })
    else
      User.all
    end.asc(:nickname).skip(skip).limit(DataTable.default_page_size)

    render 'user/list_users'
  end

  get :create_account, :map => '/create-user-account' do
    unless signed_user_has_permission? Rules::USER_CREATE_ACCOUNT
      put_message :message => 'view.create_user_account.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    params['user'] = {}
    render 'user/create_account'
  end

  post :create_new_account do
    unless signed_user_has_permission? Rules::USER_CREATE_ACCOUNT
      put_message :message => 'view.create_user_account.message.access_denied', :type => 'e'
      return render 'user/dashboard'
    end

    if User.where(:id => params[:user][:email]).exists?
      put_message :message => 'view.sign_up.message.user_already_registered', :type => 'e'
      return render 'user/create_account'
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

        redirect url :user, :create_account
      else
        put_message :message => @messages.join('<br/>'), :type => 'w', :translate => false
        render 'user/create_account'
      end
    else
      put_message :message => @messages.join('<br/>'), :type => 'w'
      render 'user/create_account'
    end
  end

end