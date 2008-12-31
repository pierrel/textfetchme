require 'test_helper'

class ProspectiveUsersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:prospective_users)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_prospective_user
    assert_difference('ProspectiveUser.count') do
      post :create, :prospective_user => { }
    end

    assert_redirected_to prospective_user_path(assigns(:prospective_user))
  end

  def test_should_show_prospective_user
    get :show, :id => prospective_users(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => prospective_users(:one).id
    assert_response :success
  end

  def test_should_update_prospective_user
    put :update, :id => prospective_users(:one).id, :prospective_user => { }
    assert_redirected_to prospective_user_path(assigns(:prospective_user))
  end

  def test_should_destroy_prospective_user
    assert_difference('ProspectiveUser.count', -1) do
      delete :destroy, :id => prospective_users(:one).id
    end

    assert_redirected_to prospective_users_path
  end
end
