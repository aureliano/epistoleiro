require 'spec_helper'

describe DataTable do

  it 'asserts default class attribute values' do
    d = DataTable.new
    expect(d.page_size).to eq DataTable.default_page_size
    expect(d.page_block_size).to eq DataTable.default_page_block_size
    expect(d.columns.size).to eq 0
    expect(d.total).to eq 0
    expect(d.pages).to eq 0
    expect(d.page_index).to eq 1
    expect(d.current_page_block).to eq 1..1
  end

  it 'asserts static class attribute values' do
    d = DataTable.new do |d|
      d.page_size = 5
      d.page_block_size = 8
      d.columns = [DataColumn.new({}), DataColumn.new({})]
      d.total = 10
      d.page_index = 2
    end

    expect(d.page_size).to eq 5
    expect(d.page_block_size).to eq 8
    expect(d.columns.size).to eq 2
    expect(d.total).to eq 10
    expect(d.page_index).to eq 2

    d.page_index = 3
    d.calculate_attribute_values
    expect(d.page_index).to eq 2
  end

  it 'asserts calculated class attribute values' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.columns = [DataColumn.new({}), DataColumn.new({})]
      d.total = 45
    end

    expect(d.pages).to eq 5
    expect(d.page_index).to eq 1
    expect(d.current_page_block).to eq 1..5
  end

  it 'has next page?' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.total = 45
    end

    expect(d.has_next_page?).to be true
    
    expect(d.next_page).to eq 2
    expect(d.has_next_page?).to be true
    
    d.page_index = 2
    expect(d.next_page).to eq 3
    expect(d.has_next_page?).to be true
    
    d.page_index = 3
    expect(d.next_page).to eq 4
    expect(d.has_next_page?).to be true
    
    d.page_index = 4
    expect(d.next_page).to eq 5
    expect(d.has_next_page?).to be true
    
    d.page_index = 5
    expect(d.next_page).to eq 5
    expect(d.has_next_page?).to be false
  end

  it 'has previous page?' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.total = 30
    end

    d.page_index = 3
    expect(d.previous_page).to eq 2
    expect(d.has_previous_page?).to be true

    d.page_index = 2
    expect(d.previous_page).to eq 1
    expect(d.has_previous_page?).to be true

    d.page_index = 1
    expect(d.previous_page).to eq 1
    expect(d.has_previous_page?).to be false
  end

  it 'has page index?' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.total = 30
    end

    expect(d.has_page_index? 1).to be true
    expect(d.has_page_index? 2).to be true
    expect(d.has_page_index? 3).to be true
    expect(d.has_page_index? 4).to be false
  end

  it 'has next pagination block?' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.total = 300
    end

    expect(d.has_next_pagination_block?).to be true
    expect(d.next_block_page).to eq 11

    d.page_index = 11
    expect(d.next_block_page).to eq 21
    expect(d.has_next_pagination_block?).to be true

    d.page_index = 29
    d.calculate_attribute_values
    expect(d.next_block_page).to eq 29
    expect(d.has_next_pagination_block?).to be false
  end

  it 'has previous pagination block?' do
    d = DataTable.new do |d|
      d.page_size = 10
      d.total = 300
    end

    d.page_index = 30
    d.calculate_attribute_values
    expect(d.has_previous_pagination_block?).to be true
    expect(d.previous_block_page).to eq 20

    d.page_index = 20
    d.calculate_attribute_values
    expect(d.previous_block_page).to eq 10
    expect(d.has_previous_pagination_block?).to be true

    d.page_index = 9
    d.calculate_attribute_values
    expect(d.previous_block_page).to eq 9
    expect(d.has_previous_pagination_block?).to be false
  end

end