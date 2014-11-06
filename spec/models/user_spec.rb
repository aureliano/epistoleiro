# encoding: utf-8

require 'spec_helper'

describe User do

  it 'validates read access for all instance variables' do
    user = User.new
    expect(user).to respond_to :_id
    expect(user).to respond_to :nickname
    expect(user).to respond_to :first_name
    expect(user).to respond_to :last_name
    expect(user).to respond_to :home_page
    expect(user).to respond_to :phones
    expect(user).to respond_to :password
    expect(user).to respond_to :activation_key
    expect(user).to respond_to :active
    expect(user).to respond_to :salt
    expect(user).to respond_to :feature_permissions
    expect(user).to respond_to :tags
    expect(user).to respond_to :groups
    expect(user).to respond_to 'has_permission?'
  end

  it 'validates write access for all instance variables' do
    user = User.new
    expect(user).to respond_to '_id='
    expect(user).to respond_to 'nickname='
    expect(user).to respond_to 'first_name='
    expect(user).to respond_to 'last_name='
    expect(user).to respond_to 'home_page='
    expect(user).to respond_to 'phones='
    expect(user).to respond_to 'password='
    expect(user).to respond_to 'activation_key='
    expect(user).to respond_to 'active='
    expect(user).to respond_to 'salt='
    expect(user).to respond_to 'feature_permissions='
    expect(user).to respond_to 'tags='
    expect(user).to respond_to 'groups='
  end

  it 'validates default password hash iteration size' do
    expect(User.password_hash_iteration_size).to be 10
  end

  it 'validates default salt number size' do
    expect(User.salt_number_size).to be 3
  end

  it 'generates a password hash' do
    raw_password = 'Change123'
    password = User.generate_password_hash raw_password, 'R5T2q'

    expect(raw_password).not_to eq password
    expect(password).to eq '204628ff2022741b1890013c0c1b9a80'
    expect(password).to eq User.generate_password_hash(raw_password, 'R5T2q')
  end

  it 'generates a salt number' do
    for i in 1..50 do
      salt = User.generate_salt
      expect(salt).not_to be nil
      expect(salt.size).to be 3
      expect(salt.match(/[a-zA-Z0-9]{3}/)).not_to be nil
    end
  end

  it 'generates a validation key' do
    salt = 'wim'
    password = User.generate_password_hash '12345', salt
    expected = 'b285c0ce472cb76a90cb0bc4fa7c426dd4fa7d7c1db466602351002cbfcd3263'

    expect(User.generate_activation_key password, salt).to eq expected
  end

  it 'validates required fields' do
    expect { User.create! }.to raise_error
    expect { User.create! :first_name => 'Monkey' }.to raise_error
    expect { User.create! :first_name => 'Monkey', :last_name => 'User' }.to raise_error
    expect { User.create! :first_name => 'Monkey', :last_name => 'User', :password => 'password', :salt => '123' }.to raise_error
    expect { User.create! :first_name => 'Monkey', :last_name => 'User', :password => 'password', :salt => '123', :activation_key => '123456' }.to raise_error
    expect { User.create! :first_name => 'Monkey', :last_name => 'User', :password => 'password', :salt => '123', :activation_key => '123456', :active => false }.to raise_error
    
    user = User.new :first_name => 'Monkey', :last_name => 'User', :password => 'password', :salt => '123', :activation_key => '123456', :active => false
    user.id = 'test@mail.com'
    expect { user.save! }.to raise_error

    user.nickname = 'nickname'
    expect { user.save! }.not_to raise_error
  end

  it 'validates minimum size of text fields' do
    expect { User.create! :first_name => '12', :last_name => '123', :password => '12345', :salt => '123', :activation_key => '123456', :active => false }.to raise_error
    expect { User.create! :first_name => '123', :last_name => '12', :password => '12345', :salt => '123', :activation_key => '123456', :active => false }.to raise_error
    expect { User.create! :first_name => '123', :last_name => '123', :password => '12345', :salt => '123', :activation_key => '123456', :active => false }.to raise_error

    user = User.new :nickname => 'nickname', :first_name => '123', :last_name => '123', :password => '12345', :salt => '123', :activation_key => '123456', :active => false
    user.id = 'a@e'
    expect { user.save! }.to raise_error

    user.id = 'test@mail.com'
    user.nickname = 'ab'
    expect { user.save! }.to raise_error

    user.nickname = 'nickname'
    expect { user.save! }.not_to raise_error
  end

  it 'validates maximum size of text fields' do
    expect { User.create! :first_name => '*' * 51, :last_name => '*' * 50, :password => '*' * 30, :salt => '123', :activation_key => '123456', :active => false }.to raise_error
    expect { User.create! :first_name => '*' * 50, :last_name => '*' * 51, :password => '*' * 30, :salt => '123', :activation_key => '123456', :active => false }.to raise_error
    expect { User.create! :first_name => '*' * 50, :last_name => '*' * 50, :password => '*' * 30, :salt => '123', :activation_key => '123456', :active => false }.to raise_error

    user = User.new :nickname => 'nickname', :first_name => '*' * 50, :last_name => '*' * 50, :password => '*' * 30, :salt => '123', :activation_key => '123456', :active => false
    user.id = 'a' * 51
    expect { user.save! }.to raise_error

    user.id = 'test@mail.com'
    user.nickname = 'nickname'
    expect { user.save! }.not_to raise_error
  end

  it "validates nickname's format" do
    user = User.new :first_name => '*' * 50, :last_name => '*' * 50, :password => '*' * 30, :salt => '123', :activation_key => '123456', :active => false
    user.id = 'test@test.com'
    user.nickname = 'coração'

    expect { user.save! }.to raise_error

    user.nickname = 'caça'
    expect { user.save! }.to raise_error

    user.nickname = 'cross*'
    expect { user.save! }.to raise_error

    user.nickname = 'cross'
    expect { user.save! }.not_to raise_error
  end

  it 'checks user permissions' do
    user = create_user
    expect(user.has_permission? Rules::WATCHER).to be true

    user.feature_permissions.clear
    expect(user.has_permission? Rules::WATCHER).to be false

    user.feature_permissions << Rules::WATCHER
    expect(user.has_permission? Rules::WATCHER).to be true

    user.feature_permissions << Rules::USER_MANAGE_STATUS
    expect(user.has_permission? Rules::WATCHER).to be true
    expect(user.has_permission? Rules::USER_MANAGE_STATUS).to be true
    expect(user.has_permission? Rules::USER_MANAGE_PERMISSIONS).to be false

    user.feature_permissions << Rules::USER_MANAGE_PERMISSIONS
    expect(user.has_permission? Rules::USER_MANAGE_PERMISSIONS).to be true
  end

  it 'asserts user access to feature' do
    user = create_user
    expect(user.has_access_to_feature? Features::USER_LIST).to be false

    user.feature_permissions << Rules::USER_MANAGE_STATUS
    expect(user.has_access_to_feature? Features::USER_LIST).to be true

    user.feature_permissions.clear
    user.feature_permissions << Rules::USER_CREATE_ACCOUNT
    expect(user.has_access_to_feature? Features::USER_LIST).to be true

    user.feature_permissions.clear
    user.feature_permissions << Rules::USER_DELETE_ACCOUNT
    expect(user.has_access_to_feature? Features::USER_LIST).to be true

    user.feature_permissions.clear
    user.feature_permissions << Rules::USER_MANAGE_PERMISSIONS
    expect(user.has_access_to_feature? Features::USER_LIST).to be true
  end

  it 'resets password' do
    user = create_user
    pass = user.password.dup
    salt = user.salt.dup
    activation_key = user.activation_key.dup

    expect(user.password).to eq pass
    expect(user.salt).to eq salt
    expect(user.activation_key).to eq activation_key

    user.reset_password
    expect(user.password).not_to eq pass
    expect(user.salt).not_to eq salt
    expect(user.activation_key).not_to eq activation_key
  end

  it 'shows user account status as text' do
    expect(User.new.user_account_status).to eq I18n.translate 'model.user.account_status.inactive'
    expect(User.new(:active => false).user_account_status).to eq I18n.translate 'model.user.account_status.inactive'
    expect(User.new(:active => true).user_account_status).to eq I18n.translate 'model.user.account_status.active'
  end

end