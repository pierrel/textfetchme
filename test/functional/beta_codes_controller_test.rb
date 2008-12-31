require 'test_helper'

class BetaCodesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:beta_codes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_beta_code
    assert_difference('BetaCode.count') do
      post :create, :beta_code => { }
    end

    assert_redirected_to beta_code_path(assigns(:beta_code))
  end

  def test_should_show_beta_code
    get :show, :id => beta_codes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => beta_codes(:one).id
    assert_response :success
  end

  def test_should_update_beta_code
    put :update, :id => beta_codes(:one).id, :beta_code => { }
    assert_redirected_to beta_code_path(assigns(:beta_code))
  end

  def test_should_destroy_beta_code
    assert_difference('BetaCode.count', -1) do
      delete :destroy, :id => beta_codes(:one).id
    end

    assert_redirected_to beta_codes_path
  end
end
