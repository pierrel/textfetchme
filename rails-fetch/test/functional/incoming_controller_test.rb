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
    assert_response 200, 'You have been subscribed!'
  end
  
  def test_bad_activation
    post :index, :event => 'SUBSCRITION_UPDATE', :uid => 255
    assert_response 500, 'User does not exist'
  end
  
  def test_fetch
    post :index, :event => 'MO', :uid => 1, :body => 'chopin'
    assert_response 200, 'banana, artichoke, pikachu'
    
    post :index, :event => 'MO', :uid => 2, :body => 'videogAme'
    assert_response 200, 'turok'
  end
  
  def test_bad_fetch
    post :index, :event => 'MO', :uid => 1, :body => 'nonexistant'
    assert_response 200, "'nonexistant' not found. These are your triggers: SHOpping, videogame."
  end
  
  def test_add
    quentin = users(:quentin)
    hockey1 = 'played with l-shaped sticks'
    hockey2 = 'hurts'
    
    assert_equal(3, quentin.triggers.size)
    
    # staight-up add
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey1}"
    assert_response 200, "added 'hockey' as '#{hockey1}'"
    #assert_equal(4, quentin.triggers.size)
    assert_not_nil(quentin.trigger_with_key('hockey'))
    assert_equal('played with l-shaped sticks', quentin.trigger_with_key('hockey').value)
    
    # add/append
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey2}"
    assert_response 200, "added '#{hockey2}' to 'hockey'"
    assert_equal(4, quentin.triggers.size)
    assert_not_nil(quentin.trigger_with_key('hockey'))
    assert_equal("#{hockey1}, #{hockey2}", quentin.find_trigger('hockey').value)
    
    post :index, :event => 'MO', :uid => 1, :body => 'hockey'
    assert_response 200, "#{hockey1}, #{hockey2}"
  end
  
  
  def test_add_without_info
    post :index, :event => 'MO', :uid => 1, :body => "add something"
    assert_response 200, ""
    assert_not_nil(users(:quentin).trigger_with_key('something'))
    assert_equal("", users(:quentin).trigger_with_key('something').value)
  end
  
  def test_add_too_large
    post :index, :event => 'MO', :uid =>1, :body => ("too large: " + String.random(:length => 450))
    assert_response 200, "Could not add trigger because it was over 440 characters long"
  end
  
  def test_added_too_many
    post :index, :event => 'MO', :uid => 2, :body => 'add toomuch this is just too much'
    assert_response 200, "All available triggers are being used, remove one to add another."
  end
  
  def test_remove
    post :index, :event => 'MO', :uid => 2, :body => 'remove videogame'
    assert_response 200, "removed 'videogame'"
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
