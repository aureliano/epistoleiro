class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, :type => String
  field :first_name, :type => String
  field :last_name, :type => String
  field :home_page, :type => String
  field :phones, :type => Array
  field :password, :type => String
  field :activation_key, :type => String
  field :active, :type => Boolean
  field :feature_permissions, :type => Array

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password

  validates_length_of :first_name, :minimum => 3, :maximum => 50
  validates_length_of :last_name, :minimum => 3, :maximum => 50
  validates_length_of :password, :minimum => 5, :maximum => 30
  
  def self.generate_password_hash(pass, salt)
    hash = ''
    for i in 1..User.password_hash_iteration_size.to_i do
      hash = Digest::MD5.hexdigest(Digest::MD5.hexdigest("#{hash}#{pass}#{salt}"))
    end
    
    hash
  end
  
  def self.generate_salt
    chars = ('a'..'z').to_a.concat(('A'..'Z').to_a).concat((0..9).to_a)
    (1..User.salt_number_size).collect {|i| chars[Random.rand(chars.size)] }.join
  end
  
  def self.password_hash_iteration_size
    ENV['PASSWORD_HASH_ITERATION_SIZE'].to_i
  end
  
  def self.salt_number_size
    ENV['SALT_NUMBER_SIZE'].to_i
  end
  
end