require 'spec_helper'

describe "UserController" do
  
  describe 'Sign up - create_account' do
    
    before :all do
      User.delete_all
    end

    it 'validates account creation when no parameters are provided' do
      post '/user/create_account', params = { :user => { :password => '', :confirm_password => '' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.password_length')
    end

    it 'validates account creation when a password unequal to password confirmation is provided' do
      post '/user/create_account', params = { :user => { :password => '12345', :confirm_password => '54321' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.password_not_equals')
    end

    it 'validates account creation when no e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_required')
    end

    it 'validates account creation when an invalid short e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => 'ea@d'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_length')
    end

    it 'validates account creation when an invalid long e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => '@' * 51
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.id_length')
    end

    it 'validates account creation when first and last names are not provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_required')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_required')
    end

    it 'validates account creation when invalid short first and last names are provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'ab', :last_name => 'cd', :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_length')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_length')
    end

    it 'validates account creation when invalid long first and last names are provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'a' * 101, :last_name => 'b' * 101, :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include I18n.translate('model.user.validation.first_name_length')
      expect(last_response.body).to include I18n.translate('model.user.validation.last_name_length')
    end

    it 'validates account creation when invalid short home page is provided' do
      post '/user/create_account', params = {
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

      post '/user/create_account', params = {
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

      post '/user/create_account', params = {
        :user => {
          :email => 'mail@test.com', :nickname => user.nickname, :password => '12345', :confirm_password => '12345',
          :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.sign_up.message.nickname_already_in_use').rstrip
    end

    it 'creates an account' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User',
          :email => 'monkey_user@mail.com', :nickname => 'gross'
        }
      }

      expect(last_response.body).to eq ''
    end

  end

  describe 'Sign in - authentication' do

    it 'validates user authentication when a non existent e-mail is provided' do
      create_user
      post '/user/authentication', params = { :user => { :email => 'non_existent@mail.com', :password => 'whatever' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.authentication_error')
    end

    it 'validates user authentication with wrong password' do
      user = create_user
      post '/user/authentication', params = { :user => { :email => user.id, :password => 'wrong password' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.authentication_error')
    end

    it 'validates user authentication for an inative user' do
      user = create_user false
      post '/user/authentication', params = { :user => { :email => user.id, :password => 'password' } }
      
      expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
      expect(last_response.body).to include I18n.translate('view.login.message.inactive_user')
    end

    it 'authenticates a user' do
      user = create_user
      post '/user/authentication', params = { :user => { :email => user.id, :password => 'password' } }
      
      expect(last_response.body).to include "<b>#{user.nickname}</b>"
      expect(last_response.body).to include "<a href=\"/sign_out\" class=\"btn\">#{I18n.translate 'sign_out'}</a>"
    end

  end

  describe 'Sign out - clear session' do

    it 'user leaves application' do
      get '/sign_out'

      expect(last_response.body).to include "<h2>#{ENV['APP_NAME']}</h2>"
      expect(last_response.body).to include "<h3>#{I18n.translate 'view.index.presentation'}</h3>"
    end

  end

end