Feature: Activate an account
  In order to allow users to log in
  As a registered but inaticve user
  I want to active my account

  Scenario: An unregistred user tries to activate an account
  	When I go to activation page for e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	Then I have to see a message telling that there is no user with e-mail 'user@test.com'
  	And I have to see the login page
    And text field 'user_email' should have value ''

  Scenario: An inactive user tries to active an account providing a wrong activation key
  	Given there is an inactive user with e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	When I go to activation page for e-mail 'user@test.com' and activation key '000000000000'
  	Then I have to see the error message 'view.activation.message.wrong_activation_key'
  	And I have to see the login page
    And text field 'user_email' should have value ''

  Scenario: An active user go to activation page
  	Given there is an inactive user with e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	Given the user 'user@test.com' is active
  	When I go to activation page for e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	Then I have to see the warning message 'view.activation.message.user_already_active'
  	And I have to see the login page
    And text field 'user_email' should have value 'user@test.com'

  Scenario: An inactive user activates its account
  	Given there is an inactive user with e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	When I go to activation page for e-mail 'user@test.com' and activation key '5daf87sdf45sd1xcv'
  	Then I have to see the success message 'view.activation.message.success'
  	And I have to see the login page
    And text field 'user_email' should have value 'user@test.com'