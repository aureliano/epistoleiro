module Epistoleiro
  class App
    module UserHelper

      def build_user_account_creation_model(hash)
        user = User.new

        user.id = hash[:email]
        user.first_name = hash[:first_name]
        user.last_name = hash[:last_name]
        user.home_page = hash[:home_page]
        unless hash[:home_page].to_s.empty?
          user.home_page = (hash[:home_page].match /^http[s]?:\/\//) ? hash[:home_page] : "http://#{hash[:home_page]}"
        end
        user.phones = [hash[:phone_number]] unless hash[:phone_number].to_s.empty?
        
        user.salt = User.generate_salt
        user.password = User.generate_password_hash(hash[:password], user.salt)
        user.activation_key = User.generate_activation_key user.password, user.salt
        user.active = false

        user
      end
      
      def validate_user_account_creation(hash)
        messages = []
        messages << I18n.translate('model.user.validation.password_not_equals') if hash[:password] != hash[:confirm_password]
        messages << I18n.translate('model.user.validation.password_length') if hash[:password].size < 5 || hash[:password].size > 30

        messages << I18n.translate('model.user.validation.phone_number_length') if !hash[:phone_number].to_s.empty? && (hash[:phone_number].size < 8 || hash[:phone_number].size > 11)
        messages << I18n.translate('model.user.validation.home_page_length') if !hash[:home_page].to_s.empty? && (hash[:home_page].size < 15 || hash[:home_page].size > 100)

        messages
      end

    end

    helpers UserHelper
  end
end