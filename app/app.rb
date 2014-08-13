module Epistoleiro
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    get :index do
      render :index, :layout => 'public.html'
    end

    error 404 do
      render 'errors/404'
    end
  end
end