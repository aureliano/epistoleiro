require 'spec_helper'

describe "AuthenticationController" do

  before :all do
    User.delete_all
  end

  describe 'Sign up - create_account' do

    it 'validates account creation when no parameters are provided' do
      post '/authentication/create_account', params = { :user => { :password => '', :confirm_password => '' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.password_length')
    end

    it 'validates account creation when a password unequal to password confirmation is provided' do
      post '/authentication/create_account', params = { :user => { :password => '12345', :confirm_password => '54321' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.password_not_equals')
    end

    it 'validates account creation when no e-mail is provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_required')
    end

    it 'validates account creation when an invalid short e-mail is provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => 'ea@d'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_length')
    end

    it 'validates account creation when an invalid long e-mail is provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => '@' * 51
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_length')
    end

    it 'validates account creation when first and last names are not provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_required')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_required')
    end

    it 'validates account creation when invalid short first and last names are provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'ab', :last_name => 'cd', :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_length')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_length')
    end

    it 'validates account creation when invalid long first and last names are provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'a' * 101, :last_name => 'b' * 101, :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_length')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_length')
    end

    it 'validates account creation when invalid short home page is provided' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'ab', :last_name => 'cd',
          :email => 'test@mail.com', :home_page => 'http://'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.home_page_length')
    end

    it 'validates account creation to a user that already exists' do
      user = create_user

      post '/authentication/create_account', params = {
        :user => {
          :email => user.id, :nickname => 'anything', :password => '12345', :confirm_password => '12345',
          :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.sign_up.message.user_already_registered')
    end

    it 'validates account creation to a user that does not exist although provided a nickname already in use' do
      user = create_user

      post '/authentication/create_account', params = {
        :user => {
          :email => 'mail@test.com', :nickname => user.nickname, :password => '12345', :confirm_password => '12345',
          :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.sign_up.message.nickname_already_in_use')
    end

    it 'creates an account' do
      post '/authentication/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User',
          :email => 'monkey_user@mail.com', :nickname => 'gross'
        }
      }

      expect(last_response.body).to eq ''
    end

  end

  describe 'User account activation' do

    it 'validates account activation when an unregistred nickname is provided' do
      get "/user/activation/bastard/4654798asdf2134"

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.activation.message.user_does_not_exist').sub('%{nickname}', 'bastard')
    end

    it 'validates account activation when a wrong activation key is provided' do
      user = create_user false
      get "/user/activation/#{user.nickname}/46879sad7f9as8d7f"

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.activation.message.wrong_activation_key')
    end

    it 'validates account activation when an already active user asks for activation' do
      user = create_user true
      get "/user/activation/#{user.nickname}/#{user.activation_key}"

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.activation.message.user_already_active')
    end

    it 'activates a user account' do
      user = create_user false
      get "/user/activation/#{user.nickname}/#{user.activation_key}"

      expect(last_response.body).to include '<div class="alert alert-success alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.activation.message.success')
    end

  end

  describe 'Sign in - authentication' do

    it 'validates user authentication when a non existent e-mail is provided' do
      create_user
      post '/authentication/sign_in', params = { :user => { :email => 'non_existent@mail.com', :password => 'whatever' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.authentication_error')
    end

    it 'validates user authentication with wrong password' do
      user = create_user
      post '/authentication/sign_in', params = { :user => { :email => user.id, :password => 'wrong password' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.authentication_error')
    end

    it 'validates user authentication for an inative user' do
      user = create_user false
      post '/authentication/sign_in', params = { :user => { :email => user.id, :password => 'password' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.inactive_user')
    end

    it 'authenticates a user' do
      user = create_user
      post '/authentication/sign_in', params = { :user => { :email => user.id, :password => 'password' } }
      
      expect(last_response).to be_redirect
      follow_redirect!

      expect(last_response.body).to include user.nickname
      expect(last_response.body).to include '<button class="btn btn-large dropdown-toggle" data-toggle="dropdown" href="#">'
      expect(last_response.body).to include "<img alt=\"#{user.id}\" src=\""
      expect(last_response.body).to include "<li><a id=\"sign_out\" href=\"/sign_out\"><i class=\"icon-off\"></i> #{I18n.translate 'sign_out'}</a></li>"
    end

  end

  describe 'Sign out - clear session' do

    it 'user leaves application' do
      get '/sign_out'

      expect(last_response.body).to include "<h2>#{ENV['APP_NAME']}</h2>"
      expect(last_response.body).to include "<h3>#{I18n.translate 'view.index.presentation'}</h3>"
    end

  end

  describe 'Password reset requirement' do

    it 'user asks password reset providing an inexisting e-mail address' do
      fake_email = 'fake-email@mail.com'
      post '/authentication/notify_password_change', params = { :user => { :email => fake_email } }

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.user_does_not_exist').sub('%{email}', fake_email)
    end

    it 'user asks password reset' do
      user = create_user
      post '/authentication/notify_password_change', params = { :user => { :email => user.id } }

      expect(last_response.body).to include '<div class="alert alert-info alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.notify_password_change').sub('%{email}', user.id)
    end

  end

  describe 'Password reset' do

    it 'validates password reset when a wrong nickname is provided' do
      user = create_user
      fake_nickname = 'wrong-nick-name'
      get "/user/#{fake_nickname}/reset-password/#{user.activation_key}"

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.invalid_nickname').sub('%{nickname}', fake_nickname)
    end

    it 'validates password reset when a wrong activation key is provided' do
      user = create_user
      get "/user/#{user.nickname}/reset-password/4578dfasdfasd12123xcv54xcv"

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.wrong_activation_key')
    end

    it 'validates password reset when user has not actived its account yet' do
      user = create_user false
      get "/user/#{user.nickname}/reset-password/#{user.activation_key}"

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.inactive_user')
    end

    it 'user resets its password' do
      user = create_user
      get "/user/#{user.nickname}/reset-password/#{user.activation_key}"

      expect(last_response.body).to include '<div class="alert alert-info alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.forgot_password.message.password_reseted')
    end

  end

end