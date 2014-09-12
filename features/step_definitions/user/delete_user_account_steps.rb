Then /^I have to see the account deletion success message to user '([^']+)'$/ do |nickname|
  message = I18n.translate('view.user_profile.message.user_delete_account.success').sub '%{nickname}', nickname
  step "I have to see the success message \"#{message}\""
end