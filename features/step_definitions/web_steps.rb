When /^I type '([^']*)' in '([^']+)'$/ do |text, id|
  page.find(:xpath, "//input[@id='#{id}']").set text
end

When /^I click on button '([^']+)'$/ do |button|
  click_button button
end

When /^I click on link '([^']+)'$/ do |link|
  click_link link
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

  expect(page.find(:xpath, "//div[@class='alert alert-#{message_type} alert-dismissable']/div").text).to eq message
end