Feature: Authenticate user access
  In order to authenticate myself
  As a registered user
  I want to log in

  Scenario Outline: User tries to log in with a e-mail or password
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    Given I am in login page

    When I type '<email>' in 'user_email'
    And I type '<password>' in 'user_password'
    And I click on button 'sign_in'
    Then I have to see the error message '<message>'

    Examples:
      |email        |password|message                                |
      |diff@test.com|12345   |view.login.message.authentication_error|
      |user@test.com|123     |view.login.message.authentication_error|
      |diff@test.com|123     |view.login.message.authentication_error|

  Scenario: User log in
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    Given I am in login page

    When I type 'user@test.com' in 'user_email'
    And I type '12345' in 'user_password'
    And I click on button 'sign_in'
    Then I have to see the home page of the user 'Monkey'