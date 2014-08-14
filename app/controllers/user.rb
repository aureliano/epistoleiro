Epistoleiro::App.controllers :user do
  
  post :create_account do
    @messages = validate_user_account_creation params[:user]
    if @messages.empty?
      puts 'ITS OK'
      puts @messages
      #build_user_account_creation_model(params[:user]).save
    else
      puts 'RENDER SIGN UP PAGE'
      render :signup, :layout => 'public.html'
    end
  end  

end