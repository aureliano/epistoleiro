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

def delete_all_collections
  User.delete_all
  Group.delete_all
end

def create_user(active=true)
  user = User.where(:id => 'test@mail.com').first
  if user.nil?
    user = User.new :first_name => 'Monkey', :last_name => 'User', :salt => '123', :activation_key => '123456', :active => active
    user.id = 'test@mail.com'
  end

  user.password = User.generate_password_hash('password', user.salt)
  user.active = active
  user.nickname = 'dummy'
  user.feature_permissions = [Rules::WATCHER]

  user.save!
  user
end

def create_group
  group = Group.where(:name => 'Group XVI').first
  group = Group.new :name => 'Group XVI', :description => 'A group created for test purpose.' if group.nil?

  group.save!
  group
end

def expect_login_page(body)
  expect(body).to include '<input type="email" required maxlength="100" id="user_email" name="user[email]" value=""/>'
  expect(body).to include '<input type="password" required maxlength="30" id="user_password" name="user[password]" value=""/>'
  expect(body).to include '<button type="submit" class="btn btn-info">Sign in</button>'
end

def expect_redirection_to_login_page(url)
  get url

  expect(last_response).to be_redirect
  follow_redirect!

  expect_login_page last_response.body
end