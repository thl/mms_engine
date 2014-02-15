require_relative '../test_helper'

class MediaProcessesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:media_processes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media_process
    assert_difference('MediaProcess.count') do
      post :create, :media_process => { }
    end

    assert_redirected_to media_process_path(assigns(:media_process))
  end

  def test_should_show_media_process
    get :show, :id => media_processes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => media_processes(:one).id
    assert_response :success
  end

  def test_should_update_media_process
    put :update, :id => media_processes(:one).id, :media_process => { }
    assert_redirected_to media_process_path(assigns(:media_process))
  end

  def test_should_destroy_media_process
    assert_difference('MediaProcess.count', -1) do
      delete :destroy, :id => media_processes(:one).id
    end

    assert_redirected_to media_processes_path
  end
end
