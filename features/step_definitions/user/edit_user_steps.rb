When /^I go to profile page of the user '([^']+)'$/ do |email|
  visit "/user/#{User.find(email).nickname}"
end

Then /^I have to see the user permissions configuration page$/ do
  expect(page).to have_text I18n.translate('view.permissions.permissions')
  expect(page).to have_button I18n.translate 'save'
  expect(page).to have_link I18n.translate 'cancel'
end

When /^I set user permissions to '([^']+)'$/ do |permissions|
  page.all(:xpath, "//input[@type='checkbox']").each {|checkbox| checkbox.set false }
  permissions.split(',').map {|e| e.strip }.each do |permission|
    page.find(:xpath, "//input[@id='check_#{permission.downcase}']").set true
  end
end

Then /^I have to see permissions? '([^']+)'$/ do |permissions|
  permissions.split(',').map {|e| e.strip }.each do |permission|
    key = "features.#{permission.downcase}.label"
    page.should have_xpath "//ul/li/a[text()='#{I18n.translate key}']"
  end
end

When /^I revoke all user permissions$/ do
  page.all(:xpath, "//input[@type='checkbox']").each {|checkbox| checkbox.set false }
end

Then /^I have to see the user profile edition page$/ do
  expect(page).to have_xpath "//form[@id='form_update_profile']"
  expect(page).to have_button I18n.translate 'save'
end

Then /^I have to see the list of users page$/ do
  expect(page).to have_button I18n.translate 'find'
  expect(page).to have_xpath "//table[@id='dt_users']"
end