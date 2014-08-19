Given /^I am in sign up page$/ do
  visit('/')
  step "I click on link '#{I18n.translate 'sign_up'}'"
end

Then /^I have to see the account creation success message '([^']+)' to '([^']+)'$/ do |message_key, email|
  message = I18n.translate('view.sign_up.message.success').sub '%{email}', email
  step "I have to see the success message '#{message}'"
end