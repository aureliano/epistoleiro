Then /^I have to see forgot password page$/ do
  page.should have_button I18n.translate('send')
  page.should have_link I18n.translate('sign_in')
  page.should have_link I18n.translate('sign_up')
end

Then /^I have to see the recovery password error message '([^']+)' to '([^']+)'$/ do |message_key, email|
  message = I18n.translate(message_key).sub '%{email}', email
  step "I have to see the error message '#{message}'"
end

Then /^I have to see the recovery password information message '([^']+)' to '([^']+)'$/ do |message_key, email|
  message = I18n.translate(message_key).sub '%{email}', email
  step "I have to see the information message '#{message}'"
end