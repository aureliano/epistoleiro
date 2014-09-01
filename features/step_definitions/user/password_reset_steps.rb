When /^I go to password reset confirmation page for nickname '([^']+)' and activation key '([^']+)'$/ do |nickname, activation_key|
  visit "/user/#{nickname}/reset-password/#{activation_key}"
end

Then /^I have to see a message telling that there is no such user registered with nickname '([^']+)'$/ do |nickname|
  step "I have to see the error message '#{I18n.translate('view.forgot_password.message.invalid_nickname').sub '%{nickname}', nickname}'"
end