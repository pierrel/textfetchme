require 'test_helper'
require 'overrides'

class IncomingControllerTest < ActionController::TestCase
  fixtures :users
  
  def setup
    @controller = IncomingController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_activation
    post :index, :event => 'SUBSCRITION_UPDATE', :uid => 1
    assert_zeep_response "Welcome to TextFetchMe!"
  end
  
  def test_bad_activation
    post :index, :event => 'SUBSCRITION_UPDATE', :uid => 255
    assert_response 500
    assert_equal('User does not exist', @response.body)
  end
  
  def test_fetch
    post :index, :event => 'MO', :uid => 1, :body => 'chopin'
    assert_zeep_response 'banana, artichoke, pikachu'
    
    post :index, :event => 'MO', :uid => 2, :body => 'videogAme'
    assert_zeep_response 'turok'
  end
  
  def test_bad_fetch
    post :index, :event => 'MO', :uid => 2, :body => 'nonexistant'
    assert_zeep_response "'nonexistant' not found. These are your triggers: SHOpping, videogame."
  end
  
  def test_add
    quentin = users(:quentin)
    hockey1 = 'played with l-shaped sticks'
    hockey2 = 'hurts'
    
    assert_equal(3, quentin.triggers.size)
    
    # straight-up add
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey1}"
    assert_zeep_response "added 'hockey' as '#{hockey1}'"
    assert_equal(4, quentin.triggers.size)
    assert_not_nil(quentin.trigger_with_key('hockey'))
    assert_equal('played with l-shaped sticks', quentin.trigger_with_key('hockey').value)
    
    # add/append
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey2}"
    assert_zeep_response "added 'hockey' as '#{hockey1 + ", " + hockey2}'"
    assert_equal(4, quentin.triggers.size)
    assert_not_nil(quentin.trigger_with_key('hockey'))
    assert_equal("#{hockey1}, #{hockey2}", quentin.trigger_with_key('hockey').value)
    
    post :index, :event => 'MO', :uid => 1, :body => 'hockey'
    assert_zeep_response "#{hockey1}, #{hockey2}"
  end
  
  
  def test_add_without_info
    post :index, :event => 'MO', :uid => 1, :body => "add something"
    assert_zeep_response "added 'something' as ''"
    assert_not_nil(users(:quentin).trigger_with_key('something'))
    assert_equal("", users(:quentin).trigger_with_key('something').value)
  end
  
  def test_fetch_too_large
    post :index, :event => 'MO', :uid =>3, :body => "huge"
    assert_zeep_response
  end
  
  def test_added_too_many
    post :index, :event => 'MO', :uid => 2, :body => 'add toomuch this is just too much'
    assert_zeep_response "All available triggers are being used, remove one to add another."
  end
  
  def test_remove
    post :index, :event => 'MO', :uid => 2, :body => 'remove videogame'
    assert_zeep_response "removed trigger 'videogame'"
    assert_equal(1, users(:aaron).triggers.size)
  end
  
  def test_remove_nonexistant
    post :index, :event => 'MO', :uid => 2, :body => 'remove somethingnotthere'
    assert_response 200, "No trigger called 'somethingnotthere'"
    assert(users(:aaron).triggers.size == 2)
  end
  
  def test_triggers_command
    post :index, :event => 'MO', :uid => 2, :body => 'triggers'
    assert_response 200, "2 of 2 triggers being used: SHOpping, videogame"
  end
  
  def test_help_command
    trigger = "'fetchme trigger' will text you the information associated with trigger 'trigger'\n"
    add = "'fetchme add trigger info' will add 'info' to the end of the information assiciated with trigger 'trigger'\n"
    remove = "'fetchme remove trigger' will remove the trigger 'trigger' from your account"
    
    post :index, :event => 'MO', :uid => 2, :body => "help"
    assert_response 200, (trigger + add + remove)
  end

end
