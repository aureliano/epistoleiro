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