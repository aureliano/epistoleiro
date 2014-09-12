Feature: Edit user permissions
  In order to configure a set of user permissions
  As a registered user with permission to manage permissions
  I want to edit user permissions

  Scenario: User without permission tries to manage user permissions
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    And there is an active user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the element 'edit_permissions'



  Scenario: User tries to revoke all permissions of a user
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_PERMISSIONS'
    And there is an active user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    And I click on 'edit_permissions'
    Then I have to see the user permissions configuration page

    When I revoke all user permissions
    And I click on button 'save'
    Then I have to see the error message 'view.permissions.message.user_without_any_permission'



  Scenario: User change user permissions of another user
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_PERMISSIONS'
    And there is an active user with e-mail 'another_user@test.com' and password 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    And I click on 'edit_permissions'
    Then I have to see the user permissions configuration page

    When I set user permissions to 'WATCHER'
    And I click on button 'save'
    Then I have to see permission 'WATCHER'
    And I have to see the success message 'view.permissions.message.update_success'



  Scenario: User change its own permissions set
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_MANAGE_PERMISSIONS'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on 'edit_permissions'
    Then I have to see the user permissions configuration page

    When I set user permissions to 'WATCHER, USER_MANAGE_PERMISSIONS, USER_MANAGE_STATUS'
    And I click on button 'save'
    Then I have to see permissions 'WATCHER, USER_MANAGE_PERMISSIONS, USER_MANAGE_STATUS'
    And I have to see the success message 'view.permissions.message.update_success'