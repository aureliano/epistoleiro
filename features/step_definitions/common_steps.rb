Given /^there is an active user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password
end

Given /^there is an active user with e-mail '([^']+)' and password '([^']+)' with permission to '([^']+)'$/ do |email, password, permissions|
  permissions = permissions.split(',').map {|e| e.strip }
  save_user_dummy :id => email, :password => password, :feature_permissions => permissions
end

Given /^there is an inactive user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password, :active => false
end

Given /^I am in login page$/ do
  visit url :sign_in
end

When /^I sign_out$/ do
  page.find(:xpath, '//div[@id="user_menu"]/button').click
  click_on 'sign_out'
end

When /^I access my home page with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  step "I am in login page"
  step "I type '#{email}' in 'user_email'"
  step "I type '#{password}' in 'user_password'"
  step "I click on button 'sign_in'"
end

Then /^I have to see the home page$/ do
  page.should have_text ENV['APP_NAME']
  page.should have_text I18n.translate('view.index.presentation')
  page.should have_link I18n.translate('sign_in')
  page.should have_link I18n.translate('sign_up')
end

Then /^I have to see the login page$/ do
  page.should have_link I18n.translate('sign_up')
  page.should have_button I18n.translate('sign_in')
end

Then /^I have to see the dashboard page of the user '([^']+)'$/ do |nickname|
  page.should have_text nickname
  page.should have_text I18n.translate 'view.user_dashboard.created_groups'
  page.should have_text I18n.translate 'view.user_dashboard.signed_groups'
end