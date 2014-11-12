require 'spec_helper'

describe Group do

  it 'validates read access for all instance variables' do
    group = Group.new
    expect(group).to respond_to :_id
    expect(group).to respond_to :name
    expect(group).to respond_to :description
    expect(group).to respond_to :tags
    expect(group).to respond_to :members
    expect(group).to respond_to :owner
    expect(group).to respond_to :base_group
  end

  it 'validates write access for all instance variables' do
    group = Group.new
    expect(group).to respond_to '_id='
    expect(group).to respond_to 'name='
    expect(group).to respond_to 'description='
    expect(group).to respond_to 'tags='
    expect(group).to respond_to 'members='
    expect(group).to respond_to 'owner='
    expect(group).to respond_to 'base_group='
  end

  it 'validates required fields' do
    expect { Group.create! }.to raise_error
    expect { Group.create! :name => 'New Group', :owner => Group.new }.to raise_error
    expect { Group.create! :description => 'A test group', :owner => Group.new }.to raise_error
    expect { Group.create! :name => 'New Group', :description => 'A test group' }.to raise_error
    expect { Group.create! :name => 'New Group', :description => 'A test group', :owner => Group.new }.not_to raise_error
  end

  it 'validates minimum size of text fields' do
    expect { Group.create! :name => '1', :description => 'A test group', :owner => Group.new }.to raise_error
    expect { Group.create! :name => 'OK', :description => '1234', :owner => Group.new }.to raise_error
    expect { Group.create! :name => 'OK', :description => '12345', :owner => Group.new }.not_to raise_error
  end

  it 'validates maximum size of text fields' do
    expect { Group.create! :name => '*' * 26, :description => '*' * 200, :owner => Group.new }.to raise_error
    expect { Group.create! :name => '*' * 25, :description => '*' * 201, :owner => Group.new }.to raise_error
    expect { Group.create! :name => '*' * 25, :description => '*' * 200, :owner => Group.new }.not_to raise_error
  end

  it 'validates equality' do
    g1 = Group.new :name => 'g1'
    g2 = ''

    expect(g1).not_to eq g2

    g2 = Group.new :name => 'g2'
    expect(g1).not_to eq g2

    g2.id = g1.id
    expect(g1).not_to eq g2

    g2.id = 123
    g2.name = g1.name
    expect(g1).not_to eq g2

    g2.id = g1.id
    expect(g1).to eq g2
  end

  it 'validates inequality' do
    g1 = Group.new :name => 'g1'
    g2 = ''

    expect(g1 != g2).to be true

    g2 = Group.new :name => 'g2'
    expect(g1 != g2).to be true

    g2.id = g1.id
    expect(g1 != g2).to be true

    g2.id = 123
    g2.name = g1.name
    expect(g1 != g2).to be true

    g2.id = g1.id
    expect(g1 != g2).to be false
  end

end