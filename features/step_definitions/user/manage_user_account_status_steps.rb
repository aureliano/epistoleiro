Then /^I have to see the user account status as '([^']+)'$/ do |status|
	page.find(:xpath, "//div[@id='div_user_account_status']").text.should eq I18n.translate("model.user.account_status.#{status}")
end