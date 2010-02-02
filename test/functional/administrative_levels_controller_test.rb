require File.dirname(__FILE__) + '/../test_helper'
require 'administrative_levels_controller'

# Re-raise errors caught by the controller.
class AdministrativeLevelsController; def rescue_action(e) raise e end; end

class AdministrativeLevelsControllerTest < Test::Unit::TestCase
  fixtures :administrative_levels

  def setup
    @controller = AdministrativeLevelsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:administrative_levels)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_administrative_level
    old_count = AdministrativeLevel.count
    post :create, :administrative_level => { }
    assert_equal old_count+1, AdministrativeLevel.count
    
    assert_redirected_to administrative_level_path(assigns(:administrative_level))
  end

  def test_should_show_administrative_level
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_administrative_level
    put :update, :id => 1, :administrative_level => { }
    assert_redirected_to administrative_level_path(assigns(:administrative_level))
  end
  
  def test_should_destroy_administrative_level
    old_count = AdministrativeLevel.count
    delete :destroy, :id => 1
    assert_equal old_count-1, AdministrativeLevel.count
    
    assert_redirected_to administrative_levels_path
  end
end
