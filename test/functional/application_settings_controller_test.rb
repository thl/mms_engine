require File.dirname(__FILE__) + '/../test_helper'
require 'application_settings_controller'

# Re-raise errors caught by the controller.
class ApplicationSettingsController; def rescue_action(e) raise e end; end

class ApplicationSettingsControllerTest < Test::Unit::TestCase
  fixtures :application_settings

  def setup
    @controller = ApplicationSettingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:application_settings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_application_setting
    old_count = ApplicationSetting.count
    post :create, :application_setting => { }
    assert_equal old_count+1, ApplicationSetting.count
    
    assert_redirected_to application_setting_path(assigns(:application_setting))
  end

  def test_should_show_application_setting
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_application_setting
    put :update, :id => 1, :application_setting => { }
    assert_redirected_to application_setting_path(assigns(:application_setting))
  end
  
  def test_should_destroy_application_setting
    old_count = ApplicationSetting.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ApplicationSetting.count
    
    assert_redirected_to application_settings_path
  end
end
