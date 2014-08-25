Given /^there is an active user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password
end

Given /^there is an inactive user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password, :active => false
end

Given /^I am in login page$/ do
  visit url :sign_in
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
  page.should have_link I18n.translate('sign_out')
end