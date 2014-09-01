require 'spec_helper'

describe "UserController" do
  
  before :all do
    User.delete_all
  end

  describe 'view user profile' do

    it 'validates not authenticated user access to user profile' do
      user = create_user
      get "/user/#{user.nickname}"

      expect(last_response).to be_redirect
      follow_redirect!

      expect(last_response.body).to include '<input type="email" required maxlength="100" id="user_email" name="user[email]" value=""/>'
      expect(last_response.body).to include '<input type="password" required maxlength="30" id="user_password" name="user[password]" value=""/>'
      expect(last_response.body).to include '<button type="submit" class="btn btn btn-success">Sign in</button>'
    end

    it 'validates access to a non existing user profile' do
      user = create_user
      get "/user/nonexistinguser", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }

      expect(last_response.body).to include I18n.translate('http.error.404.message')
    end

  end

end