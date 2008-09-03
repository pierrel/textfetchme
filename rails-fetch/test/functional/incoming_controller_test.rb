require 'test_helper'

class IncomingControllerTest < ActionController::TestCase
  fixtures :users
  
  def setup
    @controller = IncomingController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_activation
    post :index, :event => 'SUBSCRITION_UPDATE', :uid => 1
    assert_response :success, 'You have been subscribed!'
  end
  
  def test_bad_activation
    post :index, :event => 'SUBSCRITION_UPDATE', :uid => 255
    assert_response :missing, 'User does not exist'
  end
  
  def test_fetch
    post :index, :event => 'MO', :uid => 1, :body => 'chopin'
    assert_reponse :success, 'banana, artichoke, pikachu'
    
    post :index, :event => 'MO', uid => 2, :body => 'videogAme'
    assert_response :success, 'turok'
  end
  
  def test_bad_fetch
    post :index, :event => 'MO', :uid => 1, :body => 'nonexistant'
    assert_response :success, "'nonexistant' not found. These are your triggers: SHOpping, videogame."
  end
  
  def test_add
    quentin = users(:quentin)
    hockey1 = 'played with l-shaped sticks'
    hockey2 = 'hurts'
    
    assert(quentin.triggers.size == 3)
    
    # staight-up add
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey1}"
    assert_response :success, "added 'hockey' as '#{hockey1}'"
    assert(quentin.triggers.size == 4)
    assert(quentin.find_trigger('hockey').value == 'played with l-shaped sticks')
    
    # add/append
    post :index, :event => 'MO', :uid => 1, :body => "add hockey #{hockey2}"
    assert_response :success, "added '#{hockey2}' to 'hockey'"
    assert(quentin.triggers.size == 4)
    assert(quenting.find_trigger('hockey').value == "#{hockey1}, #{hockey2}")
    
    post :index, :event => 'MO', :uid => 1, :body 'hockey'
    assert_response :success, "#{hockey1}, #{hockey2}"
  end
  
  def test_added_too_many
    post :index, :event => 'MO', :uid => 2, :body => 'add toomuch this is just too much'
    assert_reponse :success, "All available triggers are being used, remove one to add another."
  end
  
  def test_remove
    post :index, :event => 'MO', :uid => 2, :body => 'remove videogame'
    assert_response :succcess, "removed 'videogame'"
    assert(users(:aaron).triggers.size == 1)
  end
  
  def test_remove_nonexistant
    post :index, :event => 'MO', :uid => 2, :body => 'remove somethingnotthere'
    assert_response :success, "No trigger called 'somethingnotthere'"
    assert(users(:aaron).triggers.size == 2)
  end

end
