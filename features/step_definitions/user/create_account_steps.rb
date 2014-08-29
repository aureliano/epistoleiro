Given /^I am in sign up page$/ do
  visit('/')
  step "I click on link 'sign_up'"
end

Then /^I have to see the account creation success message '([^']+)' to '([^']+)'$/ do |message_key, email|
  message = I18n.translate(message_key).sub '%{email}', email
  step "I have to see the success message '#{message}'"
end