Feature: Change group's owner
  In order to change the owner of a group
  As a registered user
  I want to change the owner of a group

  Scenario Outline: User without permission tries to change the owner of a group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'
    And I have not to see the link 'view.group_dashboard.change_owner'

    Examples:
      |perfil|
      |USER_MANAGE_STATUS|
      |USER_CREATE_ACCOUNT|
      |USER_DELETE_ACCOUNT|
      |USER_MANAGE_PERMISSIONS|
      |GROUP_DELETE_GROUP|
      |GROUP_CREATE_GROUP|



  Scenario: User tries to change the owner of a group not providing the new owner name
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_MANAGE_GROUPS'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on link 'view.group_dashboard.change_owner'
    Then I have to see the change group owner page

    When I click on button 'save'
    And I accept the confirmation message 'view.change_group_owner.message.confirmation'
    Then I have to see the warning message 'model.group.validation.owner_required'



  Scenario: The owner of a group, which does not have permission to change groups, gives his group to other user
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on link 'view.group_dashboard.change_owner'
    Then I have to see the change group owner page

    When I select 'ximbinha' in 'group_owner'
    When I click on button 'save'
    And I accept the confirmation message 'view.change_group_owner.message.confirmation'
    Then I have to see the success message 'view.change_group_owner.message.success'



  Scenario: User which is not the owner of a group but has permission changes the owner of a group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_MANAGE_GROUPS'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is an active user with e-mail 'brother@test.com' and nickname 'brother' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on link 'view.group_dashboard.change_owner'
    Then I have to see the change group owner page

    When I select 'brother' in 'group_owner'
    When I click on button 'save'
    And I accept the confirmation message 'view.change_group_owner.message.confirmation'
    Then I have to see the success message 'view.change_group_owner.message.success'