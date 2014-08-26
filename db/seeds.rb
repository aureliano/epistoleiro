user = User.new :nickname => 'chuck-norris', :first_name => 'Chuck', :last_name => 'Norris', :active => true

user.id = 'fake.email@test.com'
user.salt = User.generate_salt
user.password = User.generate_password_hash('chuck-norris', user.salt)
user.activation_key = User.generate_activation_key user.password, user.salt
user.feature_permissions = Features.constants

user.save!