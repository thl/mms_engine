require_relative '../test_helper'
require 'transformations_controller'

# Re-raise errors caught by the controller.
class TransformationsController; def rescue_action(e) raise e end; end

class TransformationsControllerTest < Test::Unit::TestCase
  fixtures :transformations

  def setup
    @controller = TransformationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:transformations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_transformation
    old_count = Transformation.count
    post :create, :transformation => { }
    assert_equal old_count+1, Transformation.count
    
    assert_redirected_to transformation_path(assigns(:transformation))
  end

  def test_should_show_transformation
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_transformation
    put :update, :id => 1, :transformation => { }
    assert_redirected_to transformation_path(assigns(:transformation))
  end
  
  def test_should_destroy_transformation
    old_count = Transformation.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Transformation.count
    
    assert_redirected_to transformations_path
  end
end
