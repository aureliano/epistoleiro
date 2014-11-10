Given /^I am in sign up page$/ do
  visit('/')
  step "I click on link 'sign_up'"
end

Then /^I have to see the account creation success message '([^']+)' to '([^']+)'$/ do |message_key, email|
  message = I18n.translate(message_key).sub '%{email}', email
  step "I have to see the success message '#{message}'"
end

Then /^I have to see the create user account page$/ do

end

Then /^I have to see the account deletion success message to user '([^']+)'$/ do |nickname|
  message = I18n.translate('view.user_profile.message.user_delete_account.success').sub '%{nickname}', nickname
  step "I have to see the success message \"#{message}\""
end

Then /^I have to see the user account status as '([^']+)'$/ do |status|
  page.find(:xpath, "//div[@id='div_user_account_status']").text.should eq I18n.translate("model.user.account_status.#{status}")
end