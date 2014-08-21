Given /^there is an active user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password
end

Given /^there is an inactive user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password, :active => false
end

Given /^I am in login page$/ do
  visit url :sign_in
end

Then /^I have to see the login page$/ do
  page.should have_link I18n.translate('sign_up')
  page.should have_button I18n.translate('sign_in')
end

Then /^I have to see the home page of the user '([^']+)'$/ do |user_name|
  page.should have_text I18n.translate('view.index.presentation')
end