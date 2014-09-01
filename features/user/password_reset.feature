Feature: Reset user password
  In order to reset my password
  As a registered user
  I want to have my new password in my mailbox

  Scenario: User tries to reset its password providing a wrong nickname
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    When I go to password reset confirmation page for nickname 'bastard' and activation key '5daf87sdf45sd1xcv'
    Then I have to see a message telling that there is no such user registered with nickname 'bastard'
    And I have to see the login page
    And text field 'user_email' should have value ''


  Scenario: User tries to reset its password providing a wrong activation key
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    When I go to password reset confirmation page for nickname 'dummy' and activation key '5daf87sdf45sd1xcv'
    Then I have to see the error message 'view.forgot_password.message.wrong_activation_key'
    And I have to see the login page
    And text field 'user_email' should have value 'user@test.com'

  Scenario: An inactive user tries to reset its password
    Given there is an inactive user with e-mail 'user@test.com' and password '12345'
    When I go to password reset confirmation page for nickname 'dummy' and activation key '000000000000000'
    Then I have to see the error message 'view.forgot_password.message.inactive_user'
    And I have to see the login page
    And text field 'user_email' should have value 'user@test.com'

  Scenario: User resets its password and receive a new one in its mailbox
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    When I go to password reset confirmation page for nickname 'dummy' and activation key '000000000000000'
    Then I have to see the information message 'view.forgot_password.message.password_reseted'
    And I have to see the login page
    And text field 'user_email' should have value 'user@test.com'