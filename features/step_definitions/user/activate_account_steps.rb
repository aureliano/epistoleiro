Given /^there is an inactive user with e-mail '([^']+)' and activation key '([^']+)'$/ do |email, activation_key|
  user = User.new(
    :first_name => 'Monkey', :last_name => 'User', :password => 'password',
    :salt => '123', :activation_key => activation_key, :active => false
  )
  user.id = email
  user.save!
end

Given /^the user '([^']+)' is active$/ do |email|
  user = User.find(email)
  user.active = true
  user.save
end

When /^I go to activation page for e-mail '([^']+)' and activation key '([^']+)'$/ do |email, activation_key|
  visit "/user/activation/#{email}/#{activation_key}"
end

Then /^I have to see a message telling that there is no user with e-mail '([^']+)'$/ do |email|
  step "I have to see the error message '#{I18n.translate('view.activation.message.user_does_not_exist').sub '%{email}', email}'"
end