Feature: Recover user password
  In order to recover a forgotten password
  As a registered user
  I want to have my password in my mailbox

  Scenario: User tries to recover a password providing an inexisting e-mail
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    Given I am in login page

    When I click on link 'forgot_password'
    Then I have to see forgot password page

    When I type 'fake-email@test.com' in 'user_email'
    And I click on button 'send'
    Then I have to see the recovery password error message 'view.forgot_password.message.user_does_not_exist' to 'fake-email@test.com'

  Scenario: User asks password recovery
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    Given I am in login page

    When I click on link 'forgot_password'
    Then I have to see forgot password page

    When I type 'user@test.com' in 'user_email'
    And I click on button 'send'
    Then I have to see the recovery password information message 'view.forgot_password.message.notify_password_change' to 'user@test.com'