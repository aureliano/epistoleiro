module Epistoleiro
  class App
    module UserHelper

      def build_user_account_creation_model(hash)
        user = User.new

        user.id = hash[:email]
        user.first_name = hash[:first_name]
        user.last_name = hash[:last_name]
        user.home_page = hash[:home_page]
        user.phones = [hash[:phone_number]]
        user.password = hash[:password]

        user
      end
      
      def validate_user_account_creation(hash)
        messages = []
        messages << I18n.translate('model.user.validation.password_not_equals') if hash[:password] != hash[:confirm_password]
        messages << I18n.translate('model.user.validation.password_length_min') if hash[:password].size < 5

        messages << I18n.translate('model.user.validation.phone_number_min') if !hash[:phone_number].nil? && hash[:phone_number].size < 8

        messages
      end

    end

    helpers UserHelper
  end
end