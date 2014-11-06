class Group
  include Mongoid::Document

  field :name, :type => String
  field :description, :type => String
  field :tags, :type => Array

  has_and_belongs_to_many :users
  embeds_many :sub_groups, :class_name => 'Group'

  validates_presence_of :name, :message => I18n.translate('model.group.validation.name_required')
  validates_presence_of :description, :message => I18n.translate('model.user.validation.description_required')

  validates_length_of :name, :minimum => 2, :maximum => 25, :message => I18n.translate('model.group.validation.name_length')
  validates_length_of :description, :minimum => 5, :maximum => 200, :message => I18n.translate('model.group.validation.description_length')

  def update_tags
    chars = YAML.load_file 'config/characters.yml'
    tokens = []
    tokens << self.name.to_s.downcase.split(/\s+/)
    tokens << self.description.to_s.downcase.split(/\s+/)

    self.tags = tokens.flatten.uniq
    self.tags.each do |tag|
      chars.keys.each {|char| tag.sub! char, chars[char] }
      tag.downcase!
    end
  end

end