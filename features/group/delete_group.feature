Feature: Delete group
  In order to delete a group
  As a registered user with permission to delete groups
  I want to delete a group

  Scenario Outline: User without permission tries to delete a group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'
    And I have not to see the button 'delete'

    Examples:
    |perfil|
    |USER_MANAGE_STATUS|
    |USER_CREATE_ACCOUNT|
    |USER_DELETE_ACCOUNT|
    |USER_MANAGE_PERMISSIONS|
    |GROUP_CREATE_GROUP|



  Scenario: User without permission to delete group delete a group created by its own
    Given there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'ximbinha@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'delete'
    And I accept the confirmation message 'view.group_dashboard.message.delete_confirmation'
    Then I have to see the success message 'view.group_dashboard.message.delete_group.success'



  Scenario: User declines to delete a group
    Given there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'ximbinha@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'delete'    
    And I decline the confirmation message 'view.group_dashboard.message.delete_confirmation'
    Then I have to see the dashboard page of the group 'GRP_XVI'



  Scenario: User deletes a group created by another user
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_DELETE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'delete'
    And I accept the confirmation message 'view.group_dashboard.message.delete_confirmation'
    Then I have to see the success message 'view.group_dashboard.message.delete_group.success'



  Scenario: User deletes a group that has a subgroup and both got deleted
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_DELETE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XV' and description 'A test group.' created by 'ximbinha@test.com'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'
    And the group 'GRP_XV' is subgroup of 'GRP_XVI'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XV'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'delete'
    And I accept the confirmation message 'view.group_dashboard.message.delete_confirmation'
    Then I have to see the success message 'view.group_dashboard.message.delete_group.success'
    And I have not to see the text 'GRP_XV'
    And I have not to see the text 'GRP_XVI'