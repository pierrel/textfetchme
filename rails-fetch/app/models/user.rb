require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login, :case_sensitive => false
  before_save :encrypt_password
  
  has_many :triggers
  belongs_to :plan
  
  # returns the user's triggers in the form of a hash, may cause issues with speed.
  def triggers_hash
    hash = Hash.new
    self.triggers.each do |trigger| 
      hash[trigger.key.downcase.to_sym] = trigger.value
      hash[trigger.key.downcase] = trigger.value
    end
    return hash
  end
  
  # Returns trigger with given key or nil if not found
  def trigger_with_key(key)
    triggers = self.triggers.select { |trigger| trigger.key.downcase == key.downcase }
    if triggers.empty?
      return nil
    else
      triggers[0]
    end
  end
  
  # returns an array of trigger keys
  def trigger_keys
    self.triggers.collect { |e| e.key }
  end
  
  # Removes trigger from the DB and returns it. Raises
  # NoTriggerToRemove if trigger does not exist
  def remove_trigger(key)
    trigger = self.trigger_with_key(key)
    
    if trigger
      trigger.destroy
      return trigger
    else
      raise NoTriggerToRemove.new("Could not find trigger '#{key}'")
    end
  end

  
  # adds trigger if it does not exist and appends the 
  # value of trigger_hash to trigger if it does. NoTriggersAvailable
  # raised if the user does not have space for another trigger.
  def add_trigger(trigger_hash)
    raise InvalidArgument.new("Must be a hash with keys :key and :value") unless trigger_hash.has_key?(:key) and trigger_hash.has_key?(:value)
    
    existing_trigger = self.trigger_with_key(trigger_hash[:key])
    if existing_trigger.nil? and self.more_triggers?
      self.triggers << Trigger.new(trigger_hash)
    elsif existing_trigger
      existing_trigger.value = existing_trigger.value + ', ' + trigger_hash[:value]
      existing_trigger.save!
    else
      raise NoTriggersAvailable
    end
  end
  
  def number_of_defaulted_triggers(default_name)
    count = 0
    self.triggers.each { |trigger| 
      count = count+1 if trigger.key.match(/^Trigger\d*/)
    }
    return count
  end
  
  
  

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # Can be optimized
  def triggers_left
    return self.plan.number_of_triggers - self.triggers.size
  end
  
  def more_triggers?
    self.triggers_left > 0
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end

class NoTriggersAvailable < Exception; end
class NoTriggerToRemove < Exception; end
