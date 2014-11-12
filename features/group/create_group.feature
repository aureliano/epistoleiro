Feature: Create a group
  In order to create groups
  As a user with permission to create groups
  I want to create a group

  Scenario: User creates a new group
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_group'
    Then I have to see the create group page

    When I type 'Group_XVI' in 'group_name'
    When I type 'A group created for test purpose.' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the success message 'view.create_group.message.success'



  Scenario Outline: User tries to create a group providing wrong values
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_group'
    Then I have to see the create group page

    When I type '<name>' in 'group_name'
    When I type '<description>' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the warning message '<message>'

      Examples:
        |name|description|message|
        |X|A group created for test purpose.|model.group.validation.name_length|
        |Group_XVI|test|model.group.validation.description_length|



  Scenario: User tries to create a group with name that is already registered
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_XVI' and description 'Some description.'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_group'
    Then I have to see the create group page

    When I type 'Group_XVI' in 'group_name'
    When I type 'Whatever' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the warning message 'model.group.validation.name_uniqueness'



  Scenario: User creates a subgroup
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_I' and description 'Some description.' created by 'user@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_group'
    Then I have to see the create group page

    When I select 'Group_I' in 'base_group'
    When I type 'Group_II' in 'group_name'
    When I type 'Subgroup of Group_I.' in text area 'group_description'
    And I click on button 'save'
    Then I have to see the success message 'view.create_group.message.success'
    And I have to see the text 'Group_II'
    And I have to see the text 'Group_I'



  Scenario: User tries to create a subgroup of a group which was not created by him
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'GROUP_CREATE_GROUP'
    And there is an active user with e-mail 'ximbinha@test.com' and nickname 'ximbinha' with permission to 'GROUP_CREATE_GROUP'
    And there is a group with name 'Group_I' and description 'Some description.' created by 'ximbinha@test.com'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_group'
    Then I have to see the create group page
    And the select box 'base_group' must not have those options 'Grupo_I'