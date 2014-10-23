Then /^I have to see the user profile edition page$/ do
  expect(page).to have_xpath "//form[@id='form_update_profile']"
  expect(page).to have_button I18n.translate 'save'
end

Then /^I have to see the list of users page$/ do
  expect(page).to have_button I18n.translate 'find'
  expect(page).to have_xpath "//table[@id='dt_users']"
end