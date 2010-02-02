require File.dirname(__FILE__) + '/../test_helper'
require 'administrative_units_controller'

# Re-raise errors caught by the controller.
class AdministrativeUnitsController; def rescue_action(e) raise e end; end

class AdministrativeUnitsControllerTest < Test::Unit::TestCase
  fixtures :administrative_units

  def setup
    @controller = AdministrativeUnitsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:administrative_units)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_administrative_unit
    old_count = AdministrativeUnit.count
    post :create, :administrative_unit => { }
    assert_equal old_count+1, AdministrativeUnit.count
    
    assert_redirected_to administrative_unit_path(assigns(:administrative_unit))
  end

  def test_should_show_administrative_unit
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_administrative_unit
    put :update, :id => 1, :administrative_unit => { }
    assert_redirected_to administrative_unit_path(assigns(:administrative_unit))
  end
  
  def test_should_destroy_administrative_unit
    old_count = AdministrativeUnit.count
    delete :destroy, :id => 1
    assert_equal old_count-1, AdministrativeUnit.count
    
    assert_redirected_to administrative_units_path
  end
end
