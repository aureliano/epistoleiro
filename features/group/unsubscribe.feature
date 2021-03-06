Feature: Group subscription
  In order to subscribe to a group
  As a registered user
  I want to subscribe to a group

  Scenario Outline: User unsubscribes from a group
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'
    And the user 'user@test.com' is member of the group 'GRP_XVI'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on button 'unsubscribe'
    Then I have to see the success message 'view.group_dashboard.message.unsubscribe.success'
    And I have not to see the nickname 'brother' in the group member list

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



  Scenario: User tries to unsubscribe from a group which he is not subscribed
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'
    And I have not to see the button 'unsubscribe'
    And I have to see the button 'subscribe'

  Scenario: User unsubscribes from a group from your dashboard
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'
    And the user 'user@test.com' is member of the group 'GRP_XVI'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I click on button 'unsubscribe'
    Then I have not to see the text 'GRP_XVI'



  Scenario: Group owner unsubscribes a user from his group
    Given there is an active user with e-mail 'user@test.com' and nickname 'brother' with permission to 'GROUP_CREATE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'user@test.com'
    And the user 'ximbinha@test.com' is member of the group 'GRP_XVI'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I unsubscribe the user 'ximbinha'
    Then I have to see the unsubscription success message to the user 'ximbinha'
    And I have not to see the nickname 'ximbinha' in the group member list