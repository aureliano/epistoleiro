Given /^there is an active user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password
end

Given /^there is an active user with e-mail '([^']+)' and nickname '([^']+)'$/ do |email, nickname|
  save_user_dummy :id => email, :password => '12345', :nickname => nickname
end

Given /^there is an active user with e-mail '([^']+)' and password '([^']+)' with permission to '([^']+)'$/ do |email, password, permissions|
  permissions = permissions.split(',').map {|e| e.strip }
  save_user_dummy :id => email, :password => password, :feature_permissions => permissions
end

Given /^there is an active user with e-mail '([^']+)' and nickname '([^']+)' with permission to '([^']+)'$/ do |email, nickname, permissions|
  permissions = permissions.split(',').map {|e| e.strip }
  save_user_dummy :id => email, :password => '12345', :nickname => nickname, :feature_permissions => permissions
end

Given /^there is an inactive user with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  save_user_dummy :id => email, :password => password, :active => false
end

Given /^there is an inactive user with e-mail '([^']+)' and nickname '([^']+)'$/ do |email, nickname|
  save_user_dummy :id => email, :nickname => nickname, :active => false
end

Given /^there is a group with name '([^']+)' and description '([^']+)'$/ do |name, description|
  save_group_dummy :name => name, :description => description
end

Given /^I am in login page$/ do
  visit url :sign_in
end

When /^I sign_out$/ do
  page.find(:xpath, '//div[@id="user_menu"]/button').click
  click_on 'sign_out'
end

When /^I select menu '(\w+)'$/ do |menu|
  find(:xpath, "//div[@id='user_menu']/button").click
  find(:xpath, "//div[@id='user_menu']/ul/li/a/span[text()='#{I18n.translate(menu)}']").click
end

When /^I access my home page with e-mail '([^']+)' and password '([^']+)'$/ do |email, password|
  step "I am in login page"
  step "I type '#{email}' in 'user_email'"
  step "I type '#{password}' in 'user_password'"
  step "I click on button 'sign_in'"
end

Then /^I have to see the home page$/ do
  expect(page).to have_text ENV['APP_NAME']
  expect(page).to have_text I18n.translate('view.index.presentation')
  expect(page).to have_link I18n.translate('sign_in')
  expect(page).to have_link I18n.translate('sign_up')
end

Then /^I have to see the login page$/ do
  expect(page).to have_link I18n.translate('sign_up')
  expect(page).to have_button I18n.translate('sign_in')
end

Then /^I have to see the dashboard page of the user '([^']+)'$/ do |nickname|
  expect(page).to have_text nickname
  expect(page).to have_text I18n.translate 'view.user_dashboard.created_groups'
  expect(page).to have_text I18n.translate 'view.user_dashboard.signed_groups'
end

Then /^I have to see the profile page of the user '([^']+)'$/ do |nickname|
  user = User.where(:nickname => nickname).first

  expect(page).to have_text I18n.translate('model.user.fields._id')
  expect(page.find(:xpath, "//div[@id='div_email']/div[@class='span8']").text).to eq user.id

  expect(page).to have_text I18n.translate('model.user.fields.nickname')
  expect(page.find(:xpath, "//div[@id='div_nickname']/div[@class='span8']").text).to eq user.nickname

  expect(page).to have_text I18n.translate('model.user.fields.first_name')
  expect(page.find(:xpath, "//div[@id='div_first_name']/div[@class='span8']").text).to eq user.first_name

  expect(page).to have_text I18n.translate('model.user.fields.last_name')
  expect(page.find(:xpath, "//div[@id='div_last_name']/div[@class='span8']").text).to eq user.last_name
end