Feature: Delete user account
  In order to delete a user account
  As a registered user with permission to delete accounts
  I want to delete a user account

  Scenario Outline: User without permission tries to delete user account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to '<perfil>'
    And there is an active user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the button 'delete'

    Examples:
    |perfil|
    |WATCHER|
    |USER_MANAGE_STATUS|
    |USER_CREATE_ACCOUNT|
    |USER_MANAGE_PERMISSIONS|



  Scenario: User tries to delete its own account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_DELETE_ACCOUNT'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on button 'delete'
    And I accept the confirmation message 'view.user_profile.message.user_delete_account.delete_confirmation'
    Then I have to see the error message 'view.user_profile.message.user_delete_account.delete_own_account'



  Scenario: User decline to delete a user account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_DELETE_ACCOUNT'
    And there is an active user with e-mail 'another_user@test.com' and nickname 'ximbinha'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    And I click on button 'delete'
    And I decline the confirmation message 'view.user_profile.message.user_delete_account.delete_confirmation'
    Then I have to see the profile page of the user 'ximbinha'



  Scenario: User delete a user account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_DELETE_ACCOUNT'
    And there is an active user with e-mail 'another_user@test.com' and nickname 'ximbinha'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    And I click on button 'delete'
    And I accept the confirmation message 'view.user_profile.message.user_delete_account.delete_confirmation'
    Then I have to see the dashboard page of the user 'dummy'
    And I have to see the account deletion success message to user 'ximbinha'