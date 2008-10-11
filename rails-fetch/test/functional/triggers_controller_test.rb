require 'test_helper'
# include AuthHelper

class TriggersControllerTest < ActionController::TestCase
  
  fixtures :users
    
  def setup
    @controller = TriggersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    with_controller(AccountsController) do
      post :login, :login => 'quentin', :password => 'test'
    end
  end
  
  
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:triggers)
  end

  def test_should_update_trigger
    put :update, :id => triggers(:Chopin).id, :trigger => { :key => 'banana' }
    assert_redirected_to :action => 'index'
  end

  def test_should_destroy_trigger
    assert_difference('Trigger.count', -1) do
      delete :destroy, :id => triggers(:Chopin).id
    end

    assert_redirected_to triggers_path
  end
  
  def test_new_trigger_for_user
    assert(users(:quentin).more_triggers?)
    
    assert_difference('Trigger.count', 1) do
      put :new_trigger_for_user
    end
  end
end
