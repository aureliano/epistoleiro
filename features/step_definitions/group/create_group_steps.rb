Then /^I have to see the create group page$/ do
  expect(page).to have_xpath "//form[@id='form_create_group']"
end