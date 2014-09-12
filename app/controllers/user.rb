Epistoleiro::App.controllers :user do
  
  before do
    validate_user_access
  end

  get :profile, :map => '/user/:nickname' do
    @signed_user = User.where(:id => session[:user_id]).only(:feature_permissions).first
    @user = User.where(:nickname => params[:nickname]).first
    
    return render('errors/404', :layout => false) if @user.nil?    
    render 'user/profile'
  end
  
  get :edit_permissions, :map => '/user/:nickname/permissions' do
    @user = User.where(:nickname => params[:nickname]).only(:nickname, :feature_permissions).first
    unless signed_user_has_permission? Features::USER_MANAGE_PERMISSIONS
      put_message :message => 'view.permissions.message.access_denied', :type => 'e'
      return render 'user/profile'
    end

    render 'user/permissions'
  end
  
  post :update_permissions do
    @user = User.where(:nickname => params[:user][:nickname]).first
    redirect url :index if @user.nil?

    unless signed_user_has_permission? Features::USER_MANAGE_PERMISSIONS
      put_message :message => 'view.permissions.message.access_denied', :type => 'e'
      return render 'user/profile'
    end

    if params[:user][:features].nil? || params[:user][:features].empty?
      put_message :message => 'view.permissions.message.user_without_any_permission', :type => 'e'
      return render 'user/profile'
    end

    @user.feature_permissions = params[:user][:features].values
    @user.save!
    
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

    unless signed_user_has_permission? Features::USER_DELETE_ACCOUNT
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

end