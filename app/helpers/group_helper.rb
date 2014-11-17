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

      def can_subscribe_to_group?(group, user, validate_uniqueness = true)
        @signed_user ||= signed_user
        if validate_uniqueness == true
          ((@signed_user == user) || (user == group.owner)) && !(group.members.include? user)
        else
          ((@signed_user == user) || (user == group.owner))
        end
      end

      def can_unsubscribe_from_group?(group, user)
        @signed_user ||= signed_user
        ((@signed_user == user) || (@signed_user == group.owner)) && (group.members.include? user)
      end

      def subscribe(outcoming_render, user = nil)
        @group = Group.where(:id => params[:group_id]).first
        user ||= User.where(:id => params[:user_id]).first
        return render('errors/404', :layout => false) if @group.nil? || user.nil?

        if !(signed_user_has_permission? Rules::WATCHER) && (@group.owner != signed_user)
          put_message :message => 'view.group_dashboard.message.subscribe.access_denied', :type => 'e'
          return render 'user/dashboard'
        end

        if @group.members.include? user
          put_message :message => I18n.translate('view.subscribe.message.user_already_subscribed').sub('%{nickname}', user.nickname), :type => 'w', :translate => false
          return render outcoming_render
        end

        @group.members ||= []
        @group.members << user

        user.subscribed_groups ||= []
        user.subscribed_groups << @group

        @group.save
        user.save
      end

      def _unsubscribe
        @group = Group.where(:id => params[:group_id]).first
        @user = User.where(:id => params[:user_id]).first
        return render('errors/404', :layout => false) if @group.nil? || @user.nil?

        unless can_unsubscribe_from_group? @group, @user
          put_message :message => 'view.group_dashboard.message.unsubscribe.access_denied', :type => 'e'
          return render 'user/dashboard'
        end

        @group.members.delete @user
        @group.save

        @user.subscribed_groups.delete @group    
        @user.save
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