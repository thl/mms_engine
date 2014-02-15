require_relative '../test_helper'
require 'quality_types_controller'

# Re-raise errors caught by the controller.
class QualityTypesController; def rescue_action(e) raise e end; end

class QualityTypesControllerTest < Test::Unit::TestCase
  fixtures :quality_types

  def setup
    @controller = QualityTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:quality_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_quality_type
    old_count = QualityType.count
    post :create, :quality_type => { }
    assert_equal old_count+1, QualityType.count
    
    assert_redirected_to quality_type_path(assigns(:quality_type))
  end

  def test_should_show_quality_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_quality_type
    put :update, :id => 1, :quality_type => { }
    assert_redirected_to quality_type_path(assigns(:quality_type))
  end
  
  def test_should_destroy_quality_type
    old_count = QualityType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, QualityType.count
    
    assert_redirected_to quality_types_path
  end
end
