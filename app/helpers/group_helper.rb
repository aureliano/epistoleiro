module Epistoleiro
  class App
    module GroupHelper

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