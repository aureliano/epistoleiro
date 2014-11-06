require 'spec_helper'

describe "GroupController" do
  
  before :all do
    delete_all_collections
  end

  describe 'manage user permissions' do

    it 'validates not authenticated user access to list groups feature' do
      expect_redirection_to_login_page "/groups"
    end

    it 'validates not authenticated user access to create group feature' do
      expect_redirection_to_login_page "/group/create"
    end

    it 'ensures only users that have permission to GROUP_CREATE_GROUP can see the create group page' do
      user = create_user
      Rules.constants.each do |rule|
        next if Rules::GROUP_CREATE_GROUP.to_s == rule.to_s
        user.feature_permissions = [rule]
        user.save

        get "/group/create", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }
        expect(last_response.body).to include '<div class="alert alert-danger alert-dismissable">'
        expect(last_response.body).to include I18n.translate 'view.create_group.message.access_denied'
      end

      user.feature_permissions = [Rules::GROUP_CREATE_GROUP]
      user.save

      get "/group/create", {}, 'rack.session' => { :user_id => user.id, :user_nickname => user.nickname }
      expect(last_response.body).to include '<form action="/group/create" accept-charset="UTF-8" method="post" id="form_create_group"'
    end

  end
end