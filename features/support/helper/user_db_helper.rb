def save_user_dummy(options)
  user = User.new
  options.each {|field, value| user.send("#{field}=", value)}

  user.nickname ||= 'dummy'
  user.first_name ||= 'Monkey'
  user.last_name ||= 'User'
  user.password ||= 'password'
  user.salt ||= '123'
  user.activation_key ||= '000000000000000'
  user.active = true if user.active.nil?

  user.password = User.generate_password_hash user.password, user.salt

  user.save!
  user
end