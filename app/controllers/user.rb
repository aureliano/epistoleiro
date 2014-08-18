Epistoleiro::App.controllers :user do
  
  post :create_account do
    @messages = validate_user_account_creation params[:user]
    if @messages.empty?
      user = build_user_account_creation_model(params[:user])
      user.save
      messages = format_validation_messages user

      if messages.empty?
        redirect url(:index, :msg => I18n.translate('view.sign_up.message.success'), :msg_type => 's')
      else
        params[:msg] = messages.join('<br/>')
        params[:msg_type] = 'w'
        render :signup, :layout => 'public.html'
      end
    else
      render :signup, :layout => 'public.html'
    end
  end  

end