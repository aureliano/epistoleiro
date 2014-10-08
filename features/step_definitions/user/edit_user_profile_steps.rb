Then /^I have to see the user profile edition page$/ do
  page.should have_xpath "//form[@id='form_update_profile']"
  page.should have_button I18n.translate 'save'
end