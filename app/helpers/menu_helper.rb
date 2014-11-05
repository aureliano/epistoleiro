module Epistoleiro
  class App
    module MenuHelper

      def build_menu
        Nokogiri::HTML::Builder.new do |doc|
          divider_printed = false

          doc.div(:id => 'user_menu', :class => 'btn-group') {
            doc.button(:class => 'btn btn-large dropdown-toggle', 'data-toggle' => 'dropdown', :href => '#') {
              doc.span session[:user_nickname]
              gravatar_image_node(doc, :email => session[:user_id], :size => 20)
              doc.span :class => 'caret'
            }

            doc.ul(:class => 'dropdown-menu') {
              doc.li {
                doc.a(:id => 'user_profile', :href => url(:user, :profile, :nickname => session[:user_nickname])) {
                  doc.i(:class => 'icon-user')
                  doc.span I18n.translate 'profile'
                }
              }

              signed_user = User.where(:id => session[:user_id]).only(:feature_permissions).first
              if signed_user.has_access_to_feature? Features::USER_LIST
                doc.li :class => 'divider'
                doc.li {
                  doc.a(:id => 'user_list_users', :href => url(:user, :list_users)) {
                    doc.i(:class => 'icon-chevron-right')
                    doc.span I18n.translate 'manage_users'
                  }
                }

                if signed_user.has_permission? Rules::USER_CREATE_ACCOUNT
                  doc.li {
                    doc.a(:id => 'user_create_account', :href => url(:user, :create_account)) {
                      doc.i(:class => 'icon-chevron-right')
                      doc.span I18n.translate 'create_user_account'
                    }
                  }
                end

                doc.li :class => 'divider'
                divider_printed = true
              end

              doc.li :class => 'divider' unless divider_printed
              if signed_user.has_permission? Rules::GROUP_CREATE_GROUP
                doc.li {
                  doc.a(:id => 'group_list_groups', :href => url(:group, :list_groups)) {
                    doc.i(:class => 'icon-chevron-right')
                    doc.span I18n.translate 'list_groups'
                  }
                }
              end

              doc.li {
                doc.a(:id => 'group_create_group', :href => '') {
                  doc.i(:class => 'icon-chevron-right')
                  doc.span I18n.translate 'create_group'
                }
              }
              doc.li :class => 'divider'

              doc.li {
                doc.a(:id => 'sign_out', :href => url(:sign_out)) {
                  doc.i(:class => 'icon-off')
                  doc.span I18n.translate 'sign_out'
                }
              }
            }
          }
        end.to_html.html_safe
      end

    end

    helpers MenuHelper
  end
end