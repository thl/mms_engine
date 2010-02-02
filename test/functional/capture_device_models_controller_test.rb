require File.dirname(__FILE__) + '/../test_helper'

class CaptureDeviceModelsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:capture_device_models)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_capture_device_model
    assert_difference('CaptureDeviceModel.count') do
      post :create, :capture_device_model => { }
    end

    assert_redirected_to capture_device_model_path(assigns(:capture_device_model))
  end

  def test_should_show_capture_device_model
    get :show, :id => capture_device_models(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => capture_device_models(:one).id
    assert_response :success
  end

  def test_should_update_capture_device_model
    put :update, :id => capture_device_models(:one).id, :capture_device_model => { }
    assert_redirected_to capture_device_model_path(assigns(:capture_device_model))
  end

  def test_should_destroy_capture_device_model
    assert_difference('CaptureDeviceModel.count', -1) do
      delete :destroy, :id => capture_device_models(:one).id
    end

    assert_redirected_to capture_device_models_path
  end
end
