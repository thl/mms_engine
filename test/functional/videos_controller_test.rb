require_relative '../test_helper'
require 'videos_controller'

# Re-raise errors caught by the controller.
class VideosController; def rescue_action(e) raise e end; end

class VideosControllerTest < Test::Unit::TestCase
  fixtures :videos

  def setup
    @controller = VideosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:videos)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_video
    old_count = Video.count
    post :create, :video => { }
    assert_equal old_count+1, Video.count
    
    assert_redirected_to video_path(assigns(:video))
  end

  def test_should_show_video
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_video
    put :update, :id => 1, :video => { }
    assert_redirected_to video_path(assigns(:video))
  end
  
  def test_should_destroy_video
    old_count = Video.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Video.count
    
    assert_redirected_to videos_path
  end
end
