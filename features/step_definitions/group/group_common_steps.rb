Given /^there is a group with name '([^']+)' and description '([^']+)'$/ do |name, description|
  step "there is a group with name '#{name}' and description '#{description}' created by ''"
end

Given /^there is a group with name '([^']+)' and description '([^']+)' created by '([^']*)'$/ do |name, description, owner|
  save_group_dummy :name => name, :description => description, :owner => User.where(:id => owner).first
end

Then /^I have to see the create group page$/ do
  expect(page).to have_xpath "//form[@id='form_create_group']"
end

When /^I go to dashboard of the group '([^']+)'$/ do |name|
  step "I select menu 'list_groups'"
  step "I type '#{name}' in 'query'"
  step "I click on button 'find'"

  page.find(:xpath, "//a/span[text()='Detail']/..").click
end

Then /^I have to see the dashboard page of the group '([^']+)'$/ do |group|
  expect(page).to have_text group
  expect(page).to have_text I18n.translate 'model.group.fields.owner'
  expect(page).to have_text I18n.translate 'view.group_dashboard.members'
  expect(page).to have_text I18n.translate 'view.group_dashboard.sub_groups'
  expect(page).to have_text I18n.translate 'view.group_dashboard.current_events'
end