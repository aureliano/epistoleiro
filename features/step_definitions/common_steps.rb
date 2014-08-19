Then /^I must see the login page$/ do
  page.should have_link I18n.translate('sign_up')
  page.should have_button I18n.translate('sign_in')
end