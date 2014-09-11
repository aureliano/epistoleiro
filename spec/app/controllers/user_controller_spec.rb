require 'spec_helper'

describe "UserController" do
  
  before :all do
    User.delete_all
  end

  def expect_login_page(body)
    expect(body).to include '<input type="email" required maxlength="100" id="user_email" name="user[email]" value=""/>'
    expect(body).to include '<input type="password" required maxlength="30" id="user_password" name="user[password]" value=""/>'
    expect(body).to include '<button type="submit" class="btn btn-info">Sign in</button>'
  end

  describe 'view user profile' do

    it 'validates not authenticated user access to user profile' do
      user = create_user
      get "/user/#{user.nickname}"

      expect(last_response).to be_redirect
      follow_redirect!

      expect_login_page last_response.body
    end

    it 'validates access to a non existing user profile' do
      user = create_user
      get "/user/nonexistinguser", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }

      expect(last_response.body).to include I18n.translate('http.error.404.message')
    end

  end

  describe 'manage user permissions' do

    describe 'access validation to manage permission feature' do

      it 'ensures only users that have permission to USER_MANAGE_PERMISSIONS can see Edit permissions button in user profile page' do
        user = create_user
        get "/user/#{user.nickname}", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }

        expect(last_response.body).not_to include "<a href=\"/user/#{user.nickname}/permissions\" class=\"btn btn-info\">#{I18n.translate 'edit'}</a>"
      end

      it 'validates access to user permissions feature only to those who has USER_MANAGE_PERMISSIONS permission' do
        user = create_user
        get "/user/#{user.nickname}/permissions", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }
                
        expect(last_response.body).to include '<div class="alert alert-warning alert-dismissable">'
        expect(last_response.body).to include I18n.translate 'view.permissions.message.access_denied'
        expect(last_response.body).not_to include "<h4>#{I18n.translate 'view.permissions.permissions'}</h4>"
        expect(last_response.body).not_to include "<input type=\"hidden\" value=\"#{user.nickname}\" id=\"user_nickname\" name=\"user[nickname]\"/>"
      end

      it 'validates not authenticated user access to user permissions feature' do
        user = create_user
        get "/user/#{user.nickname}/permissions"

        expect(last_response).to be_redirect
        follow_redirect!

        expect_login_page last_response.body
      end

    end

  end

end