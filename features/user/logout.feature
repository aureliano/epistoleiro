Feature: Finish user session
  In order to safely close application
  As a registered and signed in user
  I want to log out

  Scenario: User logs out
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    Given I am in login page

    When I type 'user@test.com' in 'user_email'
    And I type '12345' in 'user_password'
    And I click on button 'sign_in'
    Then I have to see the dashboard page of the user 'dummy'

    When I click on link 'sign_out'
    Then I have to see the home page