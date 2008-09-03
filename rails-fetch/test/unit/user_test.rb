require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users, :plans

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference User, :count do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  # def test_should_require_email
  #   assert_no_difference User, :count do
  #     u = create_user(:email => nil)
  #     assert u.errors.on(:email)
  #   end
  # end

  def test_should_reset_password
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).update_attributes(:login => 'quentin2')
    assert_equal users(:quentin), User.authenticate('quentin2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end
    
  def test_add_trigger
    assert_respond_to(users(:quentin), :add_trigger)
    
    quentin = users(:quentin)
    quentin.add_trigger(:key => 'glasses', :value => 'on desk')
    assert(quentin.triggers.size > 3)
    
    aaron = users(:aaron)
    assert_raises(NoTriggersAvailable) {
      aaron.add_trigger(:key => 'movie', :value => 'fantastic four')
    }
  end
  
  def test_hashed_triggers
    trigger = users(:aaron).triggers_hash['videogame']
    assert_not_nil(trigger)
    assert_equal(trigger, 'turok')
    
    assert_nil(users(:aaron).triggers_hash['nonexistant'])
    
  end
  
  def test_trigger_with_key
    assert_respond_to(users(:quentin), :trigger_with_key)
    
    trigger = users(:aaron).trigger_with_key('videoGame')
    assert_not_nil(trigger)
    assert_equal(trigger.value, 'turok')
    
    assert_nil(users(:aaron).trigger_with_key('nonexistant'))
  end
  
  def test_remove_trigger
    assert_respond_to(users(:quentin), :remove_trigger)
    
    quentin = users(:quentin)
    assert_equal(quentin.remove_trigger('day').value, 'tuesday')
    assert_equal(3, quentin.triggers.size)
    
    aaron = users(:aaron)
    assert_equal(aaron.remove_trigger('videogame').value, 'turok')
    #assert_equal(1, aaron.triggers.size)
    
    assert_equal(aaron.remove_trigger('shopping').value, 'pizza, ramen, mac and cheese')
    assert(aaron.triggers)
    
    assert_raises(NoTriggerToRemove) {
      aaron.remove_trigger('videogame')
    }
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
