When /^I go to profile page of the user '([^']+)'$/ do |email|
  visit "/user/#{User.find(email).nickname}"
end

Then /^I have to see the user permissions configuration page$/ do
  page.should have_text I18n.translate('view.permissions.permissions')
  page.should have_button I18n.translate 'save'
  page.should have_link I18n.translate 'cancel'
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