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
    render 'user/permissions'
  end
  
  post :update_permissions do
    @user = User.where(:nickname => params[:user][:nickname]).first
    redirect url :index if @user.nil?

    @user.feature_permissions = params[:user][:features].values
    @user.save!
    
    redirect url :user, :profile, :nickname => params[:user][:nickname]
  end

end
