Feature: Create an account
  In order to allow users join the community
  As a user with permission to create user accounts
  I want to sign another user up

  Scenario Outline: User tries to create a user account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_user_account'
    Then I have to see the create user account page

    When I type '<email>' in 'user_email'
    When I type '<nickname>' in 'user_nickname'
    And I type '<first_name>' in 'user_first_name'
    And I type '<last_name>' in 'user_last_name'
    And I type '<password>' in 'user_password'
    And I type '<confirm_passward>' in 'user_confirm_password'
    And I type '<home_page>' in 'user_home_page'
    And I type '<phone_number>' in 'user_phone_number'
    And I click on button 'sign_up'
    Then I have to see an alert with '<message_key>'

    Examples:
      |email         |nickname|first_name|last_name|password |confirm_passward|home_page          |phone_number|message_key|
      |test@email.com|dummy   |Monkey    |User     |Change123|Change12        |http://www.test.com|99587456    |model.user.validation.password_not_equals|
      |test@email.com|dummy   |Monkey    |User     |123      |123             |http://www.test.com|99587456    |model.user.validation.password_length|
      |test@email.com|dummy   |Monkey    |User     |Change123|Change123       |http://www.test.com|9958745     |model.user.validation.phone_number_length|



  Scenario: User tries to create an account to a user that is already registered with same e-mail
    Given there is an active user with e-mail 'monkey_user@mail.com' and password '12345'
    And there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_user_account'
    Then I have to see the create user account page

    When I type 'monkey_user@mail.com' in 'user_email'
    And I type 'new_nickname' in 'user_nickname'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I type '12345' in 'user_password'
    And I type '12345' in 'user_confirm_password'
    And I type 'http://www.test.com' in 'user_home_page'
    And I type '99587456' in 'user_phone_number'
    And I click on button 'sign_up'
    Then I have to see the error message 'view.sign_up.message.user_already_registered'



  Scenario: User tries to create an account to a user that is already registered with same nickname
    Given there is an active user with e-mail 'monkey_user@mail.com' and password '12345'
    And there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_user_account'
    Then I have to see the create user account page

    When I type 'new_email@mail.com' in 'user_email'
    And I type 'dummy' in 'user_nickname'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I type '12345' in 'user_password'
    And I type '12345' in 'user_confirm_password'
    And I type 'http://www.test.com' in 'user_home_page'
    And I type '99587456' in 'user_phone_number'
    And I click on button 'sign_up'
    Then I have to see the error message 'view.sign_up.message.nickname_already_in_use'



  Scenario Outline: User tries to create an account providing an invalid nickname
    Given there is an active user with e-mail 'monkey_user@mail.com' and password '12345'
    And there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_user_account'
    Then I have to see the create user account page

    When I type 'new_email@mail.com' in 'user_email'
    And I type '<nickname>' in 'user_nickname'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I type '12345' in 'user_password'
    And I type '12345' in 'user_confirm_password'
    And I type 'http://www.test.com' in 'user_home_page'
    And I type '99587456' in 'user_phone_number'
    And I click on button 'sign_up'
    Then I have to see the warning message 'model.user.validation.nickname_format'

    Examples:
      |nickname|
      |caçador|
      |coração|
      |tripé|



  Scenario: User creates a new user account
    Given there is an active user with e-mail 'user@test.com' and password '12345' with permission to 'USER_CREATE_ACCOUNT'
    When I access my home page with e-mail 'user@test.com' and password '12345'
    And I select menu 'create_user_account'
    Then I have to see the create user account page

    When I type 'test@email.com' in 'user_email'
    When I type 'ximbinha' in 'user_nickname'
    And I type 'Monkey' in 'user_first_name'
    And I type 'User' in 'user_last_name'
    And I type 'Change123' in 'user_password'
    And I type 'Change123' in 'user_confirm_password'
    And I type 'http://www.test.com' in 'user_home_page'
    And I type '99587456' in 'user_phone_number'
    And I click on button 'sign_up'
    Then I have to see the account creation success message 'view.sign_up.message.success' to 'test@email.com'