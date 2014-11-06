RACK_ENV = 'test' unless defined?(RACK_ENV)

ENV['APP_LOCATION'] = 'en'
ENV['PASSWORD_HASH_ITERATION_SIZE'] = '10'
ENV['SALT_NUMBER_SIZE'] = '3'

require File.expand_path(File.dirname(__FILE__) + "/../../config/boot")

require 'capybara/cucumber'
require 'rspec/expectations'

Capybara.default_driver = :selenium
Capybara.app_host = 'http://0.0.0.0:9292'

Capybara.app = Epistoleiro::App.tap { |app|  }

Before do
  User.delete_all
  Group.delete_all
end