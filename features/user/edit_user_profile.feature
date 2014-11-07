Feature: Edit user profile
  In order to update personal data
  As a registered user
  I want to edit my user profile

  Scenario: User tries to edit personal data of another user
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    And there is an active user with e-mail 'another_user@test.com' and nickname 'big_brother'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'another_user@test.com'
    Then I have not to see the element 'edit_profile'



  Scenario: User tries to change its e-mail to an already registered e-mail
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    And there is an active user with e-mail 'another_user@test.com' and nickname 'ximbinha'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on 'edit_profile'
    Then I have to see the user profile edition page

    When I type 'another_user@test.com' in 'user_email'
    And I click on button 'save'
    Then I have to see the error message 'view.user_profile.message.update_profile.email_already_registered'



  Scenario Outline: User tries to edit its personal data providing an invalid phone number
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on 'edit_profile'
    Then I have to see the user profile edition page

    When I type '<phone_number>' in 'user_phone_number'
    And I click on button 'save'
    Then I have to see an alert with '<message_key>'

    Examples:
      |phone_number|message_key                              |
      |564545      |model.user.validation.phone_number_length|
      |9958745     |model.user.validation.phone_number_length|



  Scenario Outline: User tries to edit its personal data providing invalid names
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on 'edit_profile'
    Then I have to see the user profile edition page

    When I type '<first_name>' in 'user_first_name'
    And I type '<last_name>' in 'user_last_name'
    And I click on button 'save'
    Then I have to see the error message '<message_key>'

    Examples:
      |first_name|last_name|message_key                            |
      |Le        |User     |model.user.validation.first_name_length|
      |Monkey    |Le       |model.user.validation.last_name_length |



  Scenario: User edits its personal data
    Given there is an active user with e-mail 'user@test.com' and password '12345'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I go to profile page of the user 'user@test.com'
    And I click on 'edit_profile'
    Then I have to see the user profile edition page

    When I type 'change@email.com' in 'user_email'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I click on button 'save'
    Then I have to see the success message 'view.user_profile.message.update_profile.success'



  Scenario: User edits personal data of another user
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    And there is an active user with e-mail 'another_user@test.com' and nickname 'ximbinha'

    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'manage_users'
    Then I have to see the list of users page

    When I type 'ximbinha' in 'query'
    And I click on button 'find'
    And I click on link 'detail'
    Then I have to see the profile page of the user 'ximbinha'

    When I click on 'edit_profile'
    Then I have to see the user profile edition page

    When I type 'Ximbinha' in 'user_first_name'
    And I click on button 'save'
    Then I have to see the success message 'view.user_profile.message.update_profile.success'