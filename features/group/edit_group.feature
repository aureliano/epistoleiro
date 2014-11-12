Feature: Edit group information
  In order to update data of a group
  As a registered user
  I want to change data of a group

  Scenario Outline: User without permission tries to edit a group which was not created by him
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to '<perfil>'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'
    And I have not to see the link 'edit'

    Examples:
      |perfil|
      |USER_MANAGE_STATUS|
      |USER_CREATE_ACCOUNT|
      |USER_DELETE_ACCOUNT|
      |USER_MANAGE_PERMISSIONS|
      |GROUP_DELETE_GROUP|
      |GROUP_MANAGE_GROUPS|



  Scenario Outline: User tries to update a group providing wrong values
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'GRP_XVI' and description 'A test group.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'GRP_XVI'
    Then I have to see the dashboard page of the group 'GRP_XVI'

    When I click on link 'edit'
    Then I have to see the edit group page

    When I type '<name>' in 'group_name'
    When I type '<description>' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the warning message '<message>'

    Examples:
      |name|description|message|
      |X|A group created for test purpose.|model.group.validation.name_length|
      |Group_XVI|test|model.group.validation.description_length|



  Scenario: User tries to update a group with name that is already registered
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_XVI' and description 'Some description.' created by 'user@test.com'
    And there is a group with name 'Test' and description 'Some description.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'Test'
    Then I have to see the dashboard page of the group 'Test'

    When I click on link 'edit'
    Then I have to see the edit group page

    When I type 'Group_XVI' in 'group_name'
    And I click on button 'save'
    Then I have to see the warning message 'model.group.validation.name_uniqueness'



  Scenario: User tries to update a subgroup of a group which was not created by him
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_I' and description 'Some description.' created by 'ximbinha@test.com'
    And there is a group with name 'Test' and description 'Some description.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'Test'
    Then I have to see the dashboard page of the group 'Test'

    When I click on link 'edit'
    Then I have to see the edit group page
    And the select box 'base_group' must not have the options 'Grupo_I'



  Scenario: User updates a group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Test' and description 'Some description.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'Test'
    Then I have to see the dashboard page of the group 'Test'

    When I click on link 'edit'
    Then I have to see the edit group page

    When I type 'Group_XVI' in 'group_name'
    When I type 'A group created for test purpose.' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the success message 'view.edit_group.message.success'



  Scenario: User makes a group changes to subgroup of another group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_I' and description 'Some description.' created by 'user@test.com'
    And there is a group with name 'Test' and description 'Some description.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'Test'
    Then I have to see the dashboard page of the group 'Test'

    When I click on link 'edit'
    Then I have to see the edit group page

    When I select 'Group_I' in 'base_group'
    And I click on button 'save'
    Then I have to see the success message 'view.edit_group.message.success'
    And I have to see the text 'Group_I'



  Scenario: User makes a subgroup change to base group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_I' and description 'Some description.' created by 'user@test.com'
    And there is a group with name 'Test' and description 'Some description.' created by 'user@test.com' with base group 'Group_I'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to dashboard of the group 'Test'
    Then I have to see the dashboard page of the group 'Test'

    When I click on link 'edit'
    Then I have to see the edit group page

    When I select with key 'select_one' in 'base_group'
    And I click on button 'save'
    Then I have to see the success message 'view.edit_group.message.success'
    And I have not to see the text 'Group_I'