module Epistoleiro
  class App
    module GroupHelper

      def combo_created_groups_by_signed_user(current_group = nil)
        signed_user.created_groups.delete_if {|group| group == current_group }.collect {|group| [group.name, group.id] }
      end

      def combo_group_owner_candidates(group)
        User.where(:feature_permissions => {'$in' => [Rules::GROUP_CREATE_GROUP]})
          .delete_if {|_user| _user == group.owner }
          .collect {|_user| [_user.nickname, _user.nickname] }
      end

      def can_delete_group?(group, user)
        user ||= signed_user
        return (group.owner.id == user.id) || (user.has_permission? Rules::GROUP_DELETE_GROUP)
      end

      def can_edit_group?(group, user)
        user ||= signed_user
        (group.owner == user) || ((user.has_permission? Rules::GROUP_CREATE_GROUP) && (@group.members.include? user))
      end

      def can_change_group_owner?(group, user)
        user ||= signed_user
        (user == group.owner) || (@signed_user.has_permission? Rules::GROUP_MANAGE_GROUPS)
      end

      def can_subscribe_to_group?(group, user)
        @signed_user ||= signed_user
        ((@signed_user == user) || (user == group.owner)) && !(group.members.include? user)
      end

      def can_unsubscribe_from_group?(group, user)
        @signed_user ||= signed_user
        ((@signed_user == user) || (user == group.owner)) && (group.members.include? user)
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