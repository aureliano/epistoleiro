class Group
  include Mongoid::Document

  field :name, :type => String
  field :description, :type => String
  field :tags, :type => Array

  has_and_belongs_to_many :members, :class_name => 'User', :inverse_of => :subscribed_goups
  belongs_to :owner, :class_name => 'User', :inverse_of => :created_groups
  embeds_many :sub_groups, :class_name => 'Group'

  validates_presence_of :name, :message => I18n.translate('model.group.validation.name_required')
  validates_presence_of :description, :message => I18n.translate('model.group.validation.description_required')

  validates_length_of :name, :minimum => 2, :maximum => 25, :message => I18n.translate('model.group.validation.name_length')
  validates_length_of :description, :minimum => 5, :maximum => 200, :message => I18n.translate('model.group.validation.description_length')

  validates_uniqueness_of :name, :message => I18n.translate('model.group.validation.name_uniqueness'), :case_sensitive => false

  def update_tags
    chars = YAML.load_file 'config/characters.yml'
    tokens = []
    tokens << self.name.to_s.downcase.split(/\s+/)
    tokens << self.description.to_s.downcase.split(/\s+/)

    self.tags = tokens.flatten.uniq
    self.tags.each do |tag|
      chars.keys.each {|char| tag.gsub! char, chars[char] }
      tag.gsub! /[,.?!]+/, ''
      tag.downcase!
    end

    self.tags.delete_if {|tag| tag.size <= 2 && tag.match(/\A[a-z]+\z/) }
  end

end