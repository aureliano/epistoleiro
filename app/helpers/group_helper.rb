module Epistoleiro
  class App
    module GroupHelper

      def signed_user_can_delete_group?(group)
        user = signed_user
        return (group.owner.id == user.id) || (user.has_permission? Rules::GROUP_DELETE_GROUP)
      end

      def build_group_creation_model(hash)
        group = Group.new

        group.name = hash[:name]
        group.description = hash[:description]

        owner = User.where(:id => session[:user_id]).first
        group.owner = owner
        group.members = [owner]

        group.update_tags

        group
      end

    end

    helpers GroupHelper
  end
end