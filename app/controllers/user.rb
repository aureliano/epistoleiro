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

end