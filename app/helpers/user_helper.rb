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
        redirect url(:sign_in) unless user_logged_in?
      end

      def signed_user_has_permission?(permission)
        @signed_user = User.where(:id => session[:user_id]).only(:feature_permissions).first
        @signed_user.has_permission? permission
      end

      def gravatar_image_tag(options)
        hash = Digest::MD5.hexdigest(options[:email])
        url = "http://www.gravatar.com/avatar/#{hash}?d=mm"
        url << "&s=#{options[:size]}" if options[:size]

        options[:name] ||= ((session[:user_name].nil?) ? options[:email] : session[:user_name])

        tag = "<img alt=\"#{options[:name]}\" src=\"#{url}\"/>"
        tag = "<a href=\"#{url.sub /&s=\d+/, '&s=500'}\">#{tag}</a>" if options[:linkable]

        tag.html_safe
      end

      def manage_user_account_status(nickname, active)
        @user = User.where(:nickname => nickname).first
        redirect url :index if @user.nil?

        unless signed_user_has_permission? Features::USER_MANAGE_STATUS
          put_message :message => 'view.user_profile.message.user_manage_status.access_denied', :type => 'e'
          return render 'user/profile'
        end

        if session[:user_id] == @user.id
          put_message :message => 'view.user_profile.message.user_manage_status.delete_own_account', :type => 'e'
          return render 'user/profile'
        end

        @user.active = active
        @user.save!

        redirect url :user, :profile, :nickname => nickname
      end

      def user_account_status(user)
        key = "model.user.account_status."
        key << ((user.nil? || user.active.nil? || user.active == false) ? 'inactive' : 'active')

        I18n.translate key
      end

      def build_user_account_creation_model(hash)
        user = User.new

        user.id = hash[:email]
        user.nickname = hash[:nickname]
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
        user.feature_permissions = [Features::WATCHER]

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

    end

    helpers UserHelper
  end
end