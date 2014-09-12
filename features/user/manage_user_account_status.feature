Feature: Manage user account status
  In order to activate or inactivate a user account
  As a registered user with permission to manage status
  I want to activate and inactivate user accounts

  Scenario Outline: User without permission tries to manage user account status
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to '<perfil>'
    And there is an inactive user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the button 'activate'

    Examples:
    |perfil|
    |WATCHER|
    |USER_CREATE_ACCOUNT|
    |USER_DELETE_ACCOUNT|
    |USER_MANAGE_PERMISSIONS|



  Scenario: User tries to activate a user account that is already active
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_STATUS'
    And there is an active user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the button 'activate'
    And I have to see the button 'inactivate'



  Scenario: User tries to inactivate a user account that is already inactive
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_STATUS'
    And there is an inactive user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the button 'inactivate'
    And I have to see the button 'activate'



  Scenario: User tries to inactivate its own account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_STATUS'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on button 'inactivate'
    Then I have to see the error message 'view.user_profile.message.user_manage_status.inactivate_own_account'



  Scenario Outline: User manage a user account status
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_STATUS'
    And there is an <user_status> user with e-mail 'another_user@test.com' and password 'ximbinha'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    And I click on button '<button_label>'
    Then I have to see the user account status as '<new_status>'

    Examples:
    |user_status|button_label|new_status|
    |active|inactivate|inactive|
    |inactive|activate|active|