Padrino.configure_apps do
  # enable :sessions
  set :session_secret, '9dc291bfcff85f994476467e5a2c8c493c958d3c55313355278914f4d347010a'
  set :protection, :except => :path_traversal
  set :protect_from_csrf, true unless RACK_ENV == 'test'
end

Padrino.mount('Epistoleiro::App', :app_file => Padrino.root('app/app.rb')).to('/')