Given /^there is an inactive user with nickname '([^']+)' and activation key '([^']+)'$/ do |nickname, activation_key|
  step "there is an inactive user with nickname '#{nickname}', e-mail 'user@test.com' and activation key '#{activation_key}'"
end

Given /^there is an inactive user with nickname '([^']+)', e-mail '([^']+)' and activation key '([^']+)'$/ do |nickname, email, activation_key|
  save_user_dummy :id => email, :nickname => nickname, :activation_key => activation_key, :active => false
end

Given /^the user '([^']+)' is active$/ do |email|
  user = User.find(email)
  user.active = true
  user.save
end

When /^I go to activation page for nickname '([^']+)' and activation key '([^']+)'$/ do |nickname, activation_key|
  visit "/user/activation/#{nickname}/#{activation_key}"
end

Then /^I have to see a message telling that there is no user with nickname '([^']+)'$/ do |nickname|
  step "I have to see the error message '#{I18n.translate('view.activation.message.user_does_not_exist').sub '%{nickname}', nickname}'"
end