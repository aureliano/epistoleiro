module Epistoleiro
  class App
    module GroupHelper

      def build_group_creation_model(hash)
        group = Group.new

        group.name = hash[:name]
        group.description = hash[:description]
        group.update_tags

        group
      end

    end

    helpers GroupHelper
  end
end