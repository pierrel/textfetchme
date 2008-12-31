class Trigger < ActiveRecord::Base
  validates_uniqueness_of :key, :scope => :user_id, :case_sensitive => false
  validates_length_of :value, :within => 1..140
  
  belongs_to :user
end
