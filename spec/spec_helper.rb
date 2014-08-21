RACK_ENV = 'test' unless defined?(RACK_ENV)

ENV['APP_LOCATION'] = 'en'
ENV['PASSWORD_HASH_ITERATION_SIZE'] = '10'
ENV['SALT_NUMBER_SIZE'] = '3'

require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end

def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end

def create_user(active=true)
  user = User.find 'test@mail.com'
  if user.nil?
    user = User.new :first_name => 'Monkey', :last_name => 'User', :salt => '123', :activation_key => '123456', :active => active
    user.id = 'test@mail.com'
  end

  user.password = User.generate_password_hash('password', user.salt)
  user.active = active
  
  user.save!
  user
end