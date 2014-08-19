Feature: Create an account
  In order to allow users join the community
  As a non registered user
  I want sign up

  Scenario Outline: unregistred user try to sign up
    Given I am in sign up page
    When I type '<email>' in 'user_email'
    And I type '<first_name>' in 'user_first_name'
    And I type '<last_name>' in 'user_last_name'
    And I type '<password>' in 'user_password'
    And I type '<confirm_passward>' in 'user_confirm_password'
    And I type '<home_page>' in 'user_home_page'
    And I type '<phone_number>' in 'user_phone_number'
    And I click on button 'Create an account'
    Then I have to see an alert with '<message_key>'

    Examples:
      |email          |first_name|last_name|password |confirm_passward|home_page          |phone_number|message_key|
      |test@email.com|Monkey    |User     |Change123|Change12        |http://www.test.com|99587456    |model.user.validation.password_not_equals|
      |test@email.com|Monkey    |User     |123      |123             |http://www.test.com|99587456    |model.user.validation.password_length|
      |test@email.com|Monkey    |User     |Change123|Change123       |http://www.test.com|9958745    |model.user.validation.phone_number_length|

  Scenario: unregistred user creates an account
    Given I am in sign up page
    When I type 'test@email.com' in 'user_email'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I type 'Change123' in 'user_password'
    And I type 'Change123' in 'user_confirm_password'
    And I type 'http://www.test.com' in 'user_home_page'
    And I type '99587456' in 'user_phone_number'
    And I click on button 'Create an account'
    Then I have to see the account creation success message 'view.sign_up.message.success' to 'test@email.com'