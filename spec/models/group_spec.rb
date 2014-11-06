require 'spec_helper'

describe Group do

  it 'validates read access for all instance variables' do
    group = Group.new
    expect(group).to respond_to :_id
    expect(group).to respond_to :name
    expect(group).to respond_to :description
    expect(group).to respond_to :tags
    expect(group).to respond_to :users
    expect(group).to respond_to :sub_groups
  end

  it 'validates write access for all instance variables' do
    group = Group.new
    expect(group).to respond_to '_id='
    expect(group).to respond_to 'name='
    expect(group).to respond_to 'description='
    expect(group).to respond_to 'tags='
    expect(group).to respond_to 'users='
    expect(group).to respond_to 'sub_groups='
  end

  it 'validates required fields' do
    expect { Group.create! }.to raise_error
    expect { Group.create! :name => 'New Group' }.to raise_error
    expect { Group.create! :description => 'A test group' }.to raise_error
    expect { Group.create! :name => 'New Group', :description => 'A test group' }.not_to raise_error
  end

  it 'validates minimum size of text fields' do
    expect { Group.create! :name => '1', :description => 'A test group' }.to raise_error
    expect { Group.create! :name => 'OK', :description => '1234' }.to raise_error
    expect { Group.create! :name => 'OK', :description => '12345' }.not_to raise_error
  end

  it 'validates maximum size of text fields' do
    expect { Group.create! :name => '*' * 26, :description => '*' * 200 }.to raise_error
    expect { Group.create! :name => '*' * 25, :description => '*' * 201 }.to raise_error
    expect { Group.create! :name => '*' * 25, :description => '*' * 200 }.not_to raise_error
  end

end