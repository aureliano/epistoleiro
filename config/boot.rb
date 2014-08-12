# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

Padrino.before_load do
  I18n.enforce_available_locales = true
  I18n.locale = ENV['APP_LOCATION'].to_sym
end

Padrino.after_load do
end

Padrino.load!