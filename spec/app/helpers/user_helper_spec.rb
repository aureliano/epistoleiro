require 'spec_helper'

describe "Epistoleiro::App::UserHelper" do
  let(:helpers){ Class.new }
  before { helpers.extend Epistoleiro::App::UserHelper }
  subject { helpers }

  it "should build a user account creation model" do
    user = subject.build_user_account_creation_model(
      :email => 'app@test.com', :first_name => 'Monkey', :last_name => 'User',
      :home_page => 'http://www.test.com', :phone_number => '87995784'
    )

    expect(user.id).to eq 'app@test.com'
    expect(user.first_name).to eq 'Monkey'
    expect(user.last_name).to eq 'User'
    expect(user.home_page).to eq 'http://www.test.com'
    expect(user.phones).to eq ['87995784']

    expect(user.salt).to_not be_nil
    expect(user.password).to_not be_nil
    expect(user.activation_key).to_not be_nil
    expect(user.active).to be false
    expect(user.feature_permissions).to eq [Features::WATCHER]

    user = subject.build_user_account_creation_model(
      :email => 'app@test.com', :first_name => 'Monkey', :last_name => 'User',
      :home_page => 'https://www.test.com', :phone_number => '87995784'
    )

    expect(user.home_page).to eq 'https://www.test.com'

    user = subject.build_user_account_creation_model(
      :email => 'app@test.com', :first_name => 'Monkey', :last_name => 'User',
      :home_page => 'www.test.com', :phone_number => '87995784'
    )

    expect(user.home_page).to eq 'http://www.test.com'
  end

  context 'validates user account creation' do
    it 'ensures password and password confirmation are equal' do
      res = subject.validate_user_account_creation(:password => 'Change123', :confirm_password => 'change123')
      expect(res).to eq ['model.user.validation.password_not_equals']
    end

    it 'validates password minimum size' do
      res = subject.validate_user_account_creation(:password => '123', :confirm_password => '123')
      expect(res).to eq ['model.user.validation.password_length']
    end

    it 'validates password maximum size' do
      pass = '0' * 31
      res = subject.validate_user_account_creation(:password => pass, :confirm_password => pass)
      expect(res).to eq ['model.user.validation.password_length']
    end

    it 'validates phone number minimum size' do
      res = subject.validate_user_account_creation(:password => 'Change123', :confirm_password => 'Change123', :phone_number => '1234567')
      expect(res).to eq ['model.user.validation.phone_number_length']
    end

    it 'validates phone number maximum size' do
      res = subject.validate_user_account_creation(:password => 'Change123', :confirm_password => 'Change123', :phone_number => '123456789012')
      expect(res).to eq ['model.user.validation.phone_number_length']
    end

    it 'validates home page minimum size' do
      res = subject.validate_user_account_creation(:password => 'Change123', :confirm_password => 'Change123', :home_page => '1234')
      expect(res).to eq ['model.user.validation.home_page_length']
    end

    it 'validates home page maximum size' do
      res = subject.validate_user_account_creation(:password => 'Change123', :confirm_password => 'Change123', :home_page => '0' * 101)
      expect(res).to eq ['model.user.validation.home_page_length']
    end
  end
end