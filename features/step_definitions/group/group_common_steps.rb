Given /^there is a group with name '([^']+)' and description '([^']+)' created by '([^']*)'$/ do |name, description, owner|
  save_group_dummy :name => name, :description => description, :owner => User.where(:id => owner).first
end

Given /^there is a group with name '([^']+)' and description '([^']+)' created by '([^']*)' with base group '([^']*)'$/ do |name, description, owner, base_group|
  save_group_dummy :name => name, :description => description, :owner => User.where(:id => owner).first, :base_group => Group.where(:name => base_group).first
end

Given /^the group '([^']+)' is subgroup of '([^']+)'$/ do |base, sub|
  base_group = Group.where(:name => base).first
  sub_group = Group.where(:name => sub).first
  sub_group.base_group = base_group

  sub_group.save!
end

Given /^the user '([^']+)' is member of the group '([^']+)'$/ do |user_id, group_name|
  user = User.find user_id
  group = Group.where(:name => group_name).first

  user.subscribed_groups = [group]
  group.members = [user]

  user.save
  group.save
end

Then /^I have to see the create group page$/ do
  expect(page).to have_xpath "//form[@id='form_create_group']"
end

Then /^I have to see the edit group page$/ do
  expect(page).to have_xpath "//form[@id='form_edit_group']"
end

Then /^I have to see the change group owner page$/ do
  expect(page).to have_xpath "//form[@id='form_change_group_owner']"
end

Then /^I have to see the subscribe user page$/ do
  expect(page).to have_text I18n.translate 'view.subscribe.warning'
end

Then /^I have to see the subscription success message to the user '([^']+)'$/ do |nickname|
  message = I18n.translate('view.subscribe.message.success').sub '%{nickname}', nickname
  step "I have to see the success message \"#{message}\""
end

Then /^I have to see the unsubscription success message to the user '([^']+)'$/ do |nickname|
  message = I18n.translate('view.group_dashboard.message.unsubscribe_user_success').sub '%{nickname}', nickname
  step "I have to see the success message \"#{message}\""
end

When /^I go to dashboard of the group '([^']+)'$/ do |name|
  step "I select menu 'list_groups'"
  step "I type '#{name}' in 'query'"
  step "I click on button 'find'"

  page.find(:xpath, "//a/span[text()='Detail']/..").click
end

When /^I unsubscribe the user '([^']+)'$/ do |nickname|
  page.find(:xpath, "//table[@id='dt_members']//td/a/span[text()='#{nickname}']/ancestor::tr//input").click
end

Then /^I have to see the dashboard page of the group '([^']+)'$/ do |group|
  expect(page).to have_text group
  expect(page).to have_text I18n.translate 'model.group.fields.owner'
  expect(page).to have_text I18n.translate 'view.group_dashboard.members'
  expect(page).to have_text I18n.translate 'view.group_dashboard.sub_groups'
  expect(page).to have_text I18n.translate 'view.group_dashboard.current_events'
end

Then /^I have to see the nickname '([^']+)' in the group member list$/ do |nickname|
  expect(page).to have_xpath "//table[@id='dt_members']//td/a/span[text()='#{nickname}']"
end

Then /^I have not to see the nickname '([^']+)' in the group member list$/ do |nickname|
  expect(page).not_to have_xpath "//table[@id='dt_members']//td/a/span[text()='#{nickname}']"
end

Then /^I have to see the warning message user already subscribed to '([^']+)'$/ do |nickname|
  message = I18n.translate('view.subscribe.message.user_already_subscribed').sub '%{nickname}', nickname
  step "I have to see the warning message \"#{message}\""
end