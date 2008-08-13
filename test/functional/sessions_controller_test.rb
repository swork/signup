require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:sessions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_session
    assert_difference('Session.count') do
      post :create, :session => { }
    end

    assert_redirected_to session_path(assigns(:session))
  end

  def test_should_show_session
    get :show, :id => sessions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => sessions(:one).id
    assert_response :success
  end

  def test_should_update_session
    put :update, :id => sessions(:one).id, :session => { }
    assert_redirected_to session_path(assigns(:session))
  end

  def test_should_destroy_session
    assert_difference('Session.count', -1) do
      delete :destroy, :id => sessions(:one).id
    end

    assert_redirected_to sessions_path
  end
end
