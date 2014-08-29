module Epistoleiro
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get :index do
      if user_logged_in?
        render 'user/dashboard'
      else
        render :index, :layout => 'public.html'
      end
    end

    get :sign_in do
      render :login, :layout => 'public.html'
    end

    get :sign_out do
      session.clear
      render :index, :layout => 'public.html'
    end

    get :sign_up do
      params['user'] = {}
      render :signup, :layout => 'public.html'
    end

    get :forgot_password do
      render 'user/forgot_password', :layout => 'public.html'
    end

    error 404 do
      render 'errors/404', :layout => false
    end
  end
end