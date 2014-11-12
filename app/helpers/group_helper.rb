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

      def combo_group_owner_candidates(group)
        User.where(:feature_permissions => {'$in' => [Rules::GROUP_CREATE_GROUP]})
          .delete_if {|_user| _user == group.owner }
          .collect {|_user| [_user.nickname, _user.nickname] }
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