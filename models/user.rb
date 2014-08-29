class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, :type => String
  field :nickname, :type => String
  field :first_name, :type => String
  field :last_name, :type => String
  field :home_page, :type => String
  field :phones, :type => Array
  field :password, :type => String
  field :activation_key, :type => String
  field :active, :type => Boolean
  field :salt, :type => String
  field :feature_permissions, :type => Array

  validates_presence_of :id, :message => I18n.translate('model.user.validation.id_required')
  validates_presence_of :nickname, :message => I18n.translate('model.user.validation.nickname_required')
  validates_presence_of :first_name, :message => I18n.translate('model.user.validation.first_name_required')
  validates_presence_of :last_name, :message => I18n.translate('model.user.validation.last_name_required')
  validates_presence_of :password, :message => I18n.translate('model.user.validation.password_required')
  validates_presence_of :salt, :message => I18n.translate('model.user.validation.salt_required')
  validates_presence_of :activation_key, :message => I18n.translate('model.user.validation.activation_key_required')
  validates_presence_of :active, :message => I18n.translate('model.user.validation.active_required')

  validates_length_of :id, :minimum => 5, :maximum => 50, :message => I18n.translate('model.user.validation.id_length')
  validates_length_of :nickname, :minimum => 3, :maximum => 15, :message => I18n.translate('model.user.validation.nickname_length')
  validates_length_of :first_name, :minimum => 3, :maximum => 50, :message => I18n.translate('model.user.validation.first_name_length')
  validates_length_of :last_name, :minimum => 3, :maximum => 50, :message => I18n.translate('model.user.validation.last_name_length')
  validates_length_of :home_page, :allow_blank => true, :minimum => 15, :maximum => 100, :message => I18n.translate('model.user.validation.home_page_length')
  
  def has_permission?(permission)
    ((!self.feature_permissions.nil?) && (self.feature_permissions.include? permission))
  end

  def reset_password
    new_pass = ''
    while new_pass.size < 5 do
      new_pass += User.generate_salt
    end
    salt = User.generate_salt

    self.salt = salt
    self.password = User.generate_password_hash new_pass, salt
    self.activation_key = User.generate_activation_key self.password, self.salt

    new_pass
  end

  def self.generate_password_hash(pass, salt)
    hash = ''
    for i in 1..User.password_hash_iteration_size do
      hash = Digest::MD5.hexdigest(Digest::MD5.hexdigest("#{hash}#{pass}#{salt}"))
    end
    
    hash
  end
  
  def self.generate_salt
    chars = ('a'..'z').to_a.concat(('A'..'Z').to_a).concat((0..9).to_a)
    (1..User.salt_number_size).collect {|i| chars[Random.rand(chars.size)] }.join
  end

  def self.generate_activation_key(password, salt)
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(salt.to_s)) +
    Digest::MD5.hexdigest(Digest::MD5.hexdigest(password.to_s))
  end
  
  def self.password_hash_iteration_size
    ENV['PASSWORD_HASH_ITERATION_SIZE'].to_i
  end
  
  def self.salt_number_size
    ENV['SALT_NUMBER_SIZE'].to_i
  end
  
end