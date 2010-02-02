require File.dirname(__FILE__) + '/../test_helper'
require 'ethnicities_controller'

# Re-raise errors caught by the controller.
class EthnicitiesController; def rescue_action(e) raise e end; end

class EthnicitiesControllerTest < Test::Unit::TestCase
  fixtures :ethnicities

  def setup
    @controller = EthnicitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:ethnicities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_ethnicity
    old_count = Ethnicity.count
    post :create, :ethnicity => { }
    assert_equal old_count+1, Ethnicity.count
    
    assert_redirected_to ethnicity_path(assigns(:ethnicity))
  end

  def test_should_show_ethnicity
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_ethnicity
    put :update, :id => 1, :ethnicity => { }
    assert_redirected_to ethnicity_path(assigns(:ethnicity))
  end
  
  def test_should_destroy_ethnicity
    old_count = Ethnicity.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Ethnicity.count
    
    assert_redirected_to ethnicities_path
  end
end
