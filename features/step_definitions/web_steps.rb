When /^I type '([^']*)' in '([^']+)'$/ do |text, id|
  page.find(:xpath, "//input[@id='#{id}']").set text
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

Then /^I have to see an alert with '([^']*)'$/ do |message|
  alert = page.driver.browser.switch_to.alert
  expect(alert.text).to eq I18n.translate(message)
  alert.accept
end

Then /^I have to see the (\w+) message '([^']+)'$/ do |type, message|
  message_type = case type
    when 'success' then 'success'
    when 'information' then 'info'
    when 'warning' then 'warning'
    when 'error' then 'danger'
  end

  message = I18n.translate(message) if (message.match(/[.\w]+/).to_s == message)
  expect(page.find(:xpath, "//div[@class='alert alert-#{message_type} alert-dismissable']/div").text).to eq message
end

Then /^text field '([\w\d]+)' should have value '([^']*)'$/ do |field, value|
  expect(page.find(:xpath, "//input[@id='#{field}']").value).to eq value
end

Then /^I have to see the button '([^']+)'$/ do |label|
  page.should have_button I18n.translate(label)
end

Then /^I have not to see the button '([^']+)'$/ do |label|
  page.should_not have_button I18n.translate(label)
end

Then /^I have to see the link '([^']+)'$/ do |label|
  page.should have_link I18n.translate(label)
end

Then /^I have not to see the link '([^']+)'$/ do |label|
  page.should_not have_link I18n.translate(label)
end

Then /^I have to see the element '([^']+)'$/ do |element_id|
  page.should have_selector "##{element_id}"
end

Then /^I have not to see the element '([^']+)'$/ do |element_id|
  page.should_not have_selector "##{element_id}"
end