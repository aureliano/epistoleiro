def save_group_dummy(options)
  group = Group.new
  options.each {|field, value| group.send("#{field}=", value)}

  group.name ||= 'group_dummy'

  if Group.where(:name => group.name).exists?
    group = Group.where(:name => group.name).first
  end

  group.description ||= 'A group created for test purpose.'
  group.update_tags

  group.save!
  group
end