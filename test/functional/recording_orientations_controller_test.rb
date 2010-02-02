require File.dirname(__FILE__) + '/../test_helper'

class RecordingOrientationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:recording_orientations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_recording_orientation
    assert_difference('RecordingOrientation.count') do
      post :create, :recording_orientation => { }
    end

    assert_redirected_to recording_orientation_path(assigns(:recording_orientation))
  end

  def test_should_show_recording_orientation
    get :show, :id => recording_orientations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => recording_orientations(:one).id
    assert_response :success
  end

  def test_should_update_recording_orientation
    put :update, :id => recording_orientations(:one).id, :recording_orientation => { }
    assert_redirected_to recording_orientation_path(assigns(:recording_orientation))
  end

  def test_should_destroy_recording_orientation
    assert_difference('RecordingOrientation.count', -1) do
      delete :destroy, :id => recording_orientations(:one).id
    end

    assert_redirected_to recording_orientations_path
  end
end
