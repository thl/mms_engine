require File.dirname(__FILE__) + '/../test_helper'
require 'renderers_controller'

# Re-raise errors caught by the controller.
class RenderersController; def rescue_action(e) raise e end; end

class RenderersControllerTest < Test::Unit::TestCase
  fixtures :renderers

  def setup
    @controller = RenderersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:renderers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_renderer
    old_count = Renderer.count
    post :create, :renderer => { }
    assert_equal old_count+1, Renderer.count
    
    assert_redirected_to renderer_path(assigns(:renderer))
  end

  def test_should_show_renderer
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_renderer
    put :update, :id => 1, :renderer => { }
    assert_redirected_to renderer_path(assigns(:renderer))
  end
  
  def test_should_destroy_renderer
    old_count = Renderer.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Renderer.count
    
    assert_redirected_to renderers_path
  end
end
