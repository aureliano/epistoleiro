module Epistoleiro
  class App
    module UserHelper

      def user_authenticated?(email, password)
        user = User.where(:id => email).first
        return false if user.nil?

        password_hash = User.generate_password_hash password, user.salt
        return user.password == password_hash
      end

      def user_logged_in?
        session[:user_id].present?
      end

      def validate_user_access
        unless user_logged_in?
          relative_url = request.url.sub /https?:\/\/[^\/]+:?\d*/, ''
          return if relative_url.start_with? '/user/activation/'
          redirect url(:sign_in) unless white_list.include? relative_url
        end
      end

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
        messages << 'model.user.validation.password_not_equals' if hash[:password] != hash[:confirm_password]
        messages << 'model.user.validation.password_length' if hash[:password].size < 5 || hash[:password].size > 30

        messages << 'model.user.validation.phone_number_length' if !hash[:phone_number].to_s.empty? && (hash[:phone_number].size < 8 || hash[:phone_number].size > 11)
        messages << 'model.user.validation.home_page_length' if !hash[:home_page].to_s.empty? && (hash[:home_page].size < 15 || hash[:home_page].size > 100)

        messages
      end

      def white_list
        [
          url(:index),
          url(:sign_in),
          url(:user, :create_account),
          url(:user, :authentication)
        ]
      end

    end

    helpers UserHelper
  end
end