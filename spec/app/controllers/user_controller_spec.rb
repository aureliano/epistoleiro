require 'spec_helper'

describe "UserController" do
  
  describe 'Sign up' do
    
    it 'validates account creation when no parameters are provided' do
      post '/user/create_account', params = { :user => { :password => '', :confirm_password => '' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'Password must have at least 5 and at most 30 characters.'
    end

    it 'validates account creation when a password unequal to password confirmation is provided' do
      post '/user/create_account', params = { :user => { :password => '12345', :confirm_password => '54321' } }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'Provided password and password confirmation are not equal.'
    end

    it 'validates account creation when no e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'e-mail is required.'
    end

    it 'validates account creation when an invalid short e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => 'ea@d'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'e-mail must have at least 5 and at most 50 characters.'
    end

    it 'validates account creation when an invalid long e-mail is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'Monkey', :last_name => 'User', :email => '@' * 51
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'e-mail must have at least 5 and at most 50 characters.'
    end

    it 'validates account creation when first and last names are not provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :email => 'test@mail.com'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'First name is required.'
      expect(last_response.body).to include 'Last name is required.'
    end

    it 'validates account creation when invalid short first and last names are provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'ab', :last_name => 'cd', :email => 'test@mail.cmo'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'First name must have at least 3 and at most 50 characters.'
      expect(last_response.body).to include 'Last name must have at least 3 and at most 50 characters.'
    end

    it 'validates account creation when invalid long first and last names are provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'a' * 101, :last_name => 'b' * 101, :email => 'test@mail.cmo'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'First name must have at least 3 and at most 50 characters.'
      expect(last_response.body).to include 'Last name must have at least 3 and at most 50 characters.'
    end

    it 'validates account creation when invalid short home page is provided' do
      post '/user/create_account', params = {
        :user => {
          :password => '12345', :confirm_password => '12345', :first_name => 'ab', :last_name => 'cd',
          :email => 'test@mail.cmo', :home_page => 'http://'
        }
      }

      expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
      expect(last_response.body).to include 'Home page must have at least 15 and at most 100 characters.'
    end

  end

end