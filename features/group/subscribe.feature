Feature: Group subscription
  In order to subscribe to a group
  As a registered user
  I want to subscribe to a group

  Scenario Outline: User subscribes to a group
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'subscribe'
    Then I have to see the success message 'view.group_dashboard.message.subscribe.success'
    And I have to see the nickname 'brother' in the group member list

    Examples:
      |perfil|
      |WATCHER|
      |USER_MANAGE_STATUS|
      |USER_CREATE_ACCOUNT|
      |USER_DELETE_ACCOUNT|
      |USER_MANAGE_PERMISSIONS|
      |GROUP_CREATE_GROUP|
      |GROUP_CREATE_GROUP|
      |GROUP_MANAGE_GROUPS|



  Scenario: User tries to subscribe to a group which he is already subscribed
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'
    And the user 'user@test.com' is member of the group 'GRP_XVI'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'
    And I have not to see the button 'subscribe'
    And I have to see the button 'unsubscribe'