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
      put_message :message => 'view.permissions.message.access_denied', :type => 'w'
      return render 'user/profile'
    end

    render 'user/permissions'
  end
  
  post :update_permissions do
    @user = User.where(:nickname => params[:user][:nickname]).first
    redirect url :index if @user.nil?

    unless signed_user_has_permission? Features::USER_MANAGE_PERMISSIONS
      put_message :message => 'view.permissions.message.access_denied', :type => 'w'
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

end