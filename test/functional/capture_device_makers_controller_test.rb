require_relative '../test_helper'

class CaptureDeviceMakersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:capture_device_makers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_capture_device_maker
    assert_difference('CaptureDeviceMaker.count') do
      post :create, :capture_device_maker => { }
    end

    assert_redirected_to capture_device_maker_path(assigns(:capture_device_maker))
  end

  def test_should_show_capture_device_maker
    get :show, :id => capture_device_makers(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => capture_device_makers(:one).id
    assert_response :success
  end

  def test_should_update_capture_device_maker
    put :update, :id => capture_device_makers(:one).id, :capture_device_maker => { }
    assert_redirected_to capture_device_maker_path(assigns(:capture_device_maker))
  end

  def test_should_destroy_capture_device_maker
    assert_difference('CaptureDeviceMaker.count', -1) do
      delete :destroy, :id => capture_device_makers(:one).id
    end

    assert_redirected_to capture_device_makers_path
  end
end
