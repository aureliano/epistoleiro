When /^I type '([^']*)' in '([^']+)'$/ do |text, id|
  page.find(:xpath, "//input[@id='#{id}']").set text
end

When /^I type '([^']*)' in text area '([^']+)'$/ do |text, id|
  page.find(:xpath, "//textarea[@id='#{id}']").set text
end

When /^I click on button '([^']+)'$/ do |button|
  click_button I18n.translate(button)
end

When /^I click on link '([^']+)'$/ do |link|
  click_link I18n.translate(link)
end

When /^I click on '([^']+)'$/ do |element_id|
  click_on element_id
end

When /^I select '([^']*)' in '([^']+)'$/ do |label, id|
  select label, :from => id
end

When /^I select with key '([^']*)' in '([^']+)'$/ do |label, id|
  select I18n.translate(label), :from => id
end

Then /^I have to see an alert with '([^']*)'$/ do |message|
  alert = page.driver.browser.switch_to.alert
  expect(alert.text).to eq I18n.translate(message)
  alert.accept
end

When /^I accept the confirmation message '([^']+)'$/ do |message|
  alert = page.driver.browser.switch_to.alert
  expect(alert.text).to eq I18n.translate(message)
  alert.accept
end

When /^I decline the confirmation message '([^']+)'$/ do |message|
  alert = page.driver.browser.switch_to.alert
  expect(alert.text).to eq I18n.translate(message)
  alert.dismiss
end

Then /^I have to see the (\w+) message "([^"]+)"$/ do |type, message|
  i_have_to_see_message type, message
end

Then /^I have to see the (\w+) message '([^']+)'$/ do |type, message|
  i_have_to_see_message type, message
end

Then /^text field '([\w\d]+)' should have value '([^']*)'$/ do |field, value|
  expect(page.find(:xpath, "//input[@id='#{field}']").value).to eq value
end

Then /^I have to see the button '([^']+)'$/ do |label|
  expect(page).to have_button I18n.translate(label)
end

Then /^I have not to see the button '([^']+)'$/ do |label|
  expect(page).not_to have_button I18n.translate(label)
end

Then /^I have to see the link '([^']+)'$/ do |label|
  expect(page).to have_link I18n.translate(label)
end

Then /^I have not to see the link '([^']+)'$/ do |label|
  expect(page).not_to have_link I18n.translate(label)
end

Then /^I have to see the element '([^']+)'$/ do |element_id|
  expect(page).to have_selector "##{element_id}"
end

Then /^I have to see the text '([^']+)'$/ do |text|
  expect(page).to have_text text
end

Then /^I have not to see the text '([^']+)'$/ do |text|
  expect(page).not_to have_text text
end

Then /^I have not to see the element '([^']+)'$/ do |element_id|
  expect(page).not_to have_selector "##{element_id}"
end

Then /^the select box '([^']+)' (must|must not) have the options '([^']+)'$/ do |select_box, qualifier, options|
  qualifier = (qualifier == 'must') ? true : false
  expect(page.has_select?(select_box, :options => options.split(/,\s?/))).to be qualifier
end

def i_have_to_see_message(type, message)
  message_type = case type
    when 'success' then 'success'
    when 'information' then 'info'
    when 'warning' then 'warning'
    when 'error' then 'danger'
  end

  raise "There's not a message of type '#{type}'" if message_type.nil?

  message = I18n.translate(message) if (message.match(/[.\w]+/).to_s == message)
  expect(page.find(:xpath, "//div[@class='alert alert-#{message_type} alert-dismissable']/div").text).to eq message
end