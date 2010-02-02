require File.dirname(__FILE__) + '/../test_helper'
require 'reproduction_types_controller'

# Re-raise errors caught by the controller.
class ReproductionTypesController; def rescue_action(e) raise e end; end

class ReproductionTypesControllerTest < Test::Unit::TestCase
  fixtures :reproduction_types

  def setup
    @controller = ReproductionTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:reproduction_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_reproduction_type
    old_count = ReproductionType.count
    post :create, :reproduction_type => { }
    assert_equal old_count+1, ReproductionType.count
    
    assert_redirected_to reproduction_type_path(assigns(:reproduction_type))
  end

  def test_should_show_reproduction_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_reproduction_type
    put :update, :id => 1, :reproduction_type => { }
    assert_redirected_to reproduction_type_path(assigns(:reproduction_type))
  end
  
  def test_should_destroy_reproduction_type
    old_count = ReproductionType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ReproductionType.count
    
    assert_redirected_to reproduction_types_path
  end
end
