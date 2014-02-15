require_relative '../test_helper'
require 'media_controller'

# Re-raise errors caught by the controller.
class MediaController; def rescue_action(e) raise e end; end

class MediaControllerTest < Test::Unit::TestCase
  fixtures :media

  def setup
    @controller = MediaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:media)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_medium
    old_count = Medium.count
    post :create, :medium => { }
    assert_equal old_count+1, Medium.count
    
    assert_redirected_to medium_path(assigns(:medium))
  end

  def test_should_show_medium
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_medium
    put :update, :id => 1, :medium => { }
    assert_redirected_to medium_path(assigns(:medium))
  end
  
  def test_should_destroy_medium
    old_count = Medium.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Medium.count
    
    assert_redirected_to media_path
  end
end
