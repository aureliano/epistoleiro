module Epistoleiro
  class App
    module GroupHelper

      def signed_user_can_delete_group?(group)
        user = signed_user
        return (group.owner.id == user.id) || (user.has_permission? Rules::GROUP_DELETE_GROUP)
      end

      def combo_created_groups_by_signed_user(current_group = nil)
        signed_user.created_groups.delete_if {|group| group == current_group }.collect {|group| [group.name, group.id] }
      end

      def build_group_creation_model(hash)
        group = Group.new

        group.name = hash[:name]
        group.description = hash[:description]

        owner = User.where(:id => session[:user_id]).first
        group.owner = owner
        group.members = [owner]
        
        group.base_group = Group.find(hash[:base_group]) unless hash[:base_group].to_s.empty?
        
        group.update_tags

        group
      end

    end

    helpers GroupHelper
  end
end