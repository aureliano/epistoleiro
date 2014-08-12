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