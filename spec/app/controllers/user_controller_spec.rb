require 'spec_helper'

describe "UserController" do
  
  before :all do
    delete_all_collections
  end

  describe 'view user profile' do

    it 'validates not authenticated user access to user profile' do
      user = create_user
      expect_redirection_to_login_page "/user/#{user.nickname}"
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

        expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
        expect(last_response.body).to include I18n.translate 'view.permissions.message.access_denied'
        expect(last_response.body).not_to include "<h4>#{I18n.translate 'view.permissions.permissions'}</h4>"
        expect(last_response.body).not_to include "<input type=\"hidden\" value=\"#{user.nickname}\" id=\"user_nickname\" name=\"user[nickname]\"/>"
      end

      it 'validates not authenticated user access to user permissions feature' do
        user = create_user
        expect_redirection_to_login_page "/user/#{user.nickname}/permissions"
      end

    end

  end

end