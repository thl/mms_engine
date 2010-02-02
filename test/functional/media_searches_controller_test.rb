require File.dirname(__FILE__) + '/../test_helper'
require 'media_searches_controller'

# Re-raise errors caught by the controller.
class MediaSearchesController; def rescue_action(e) raise e end; end

class MediaSearchesControllerTest < Test::Unit::TestCase
  fixtures :media_searches

  def setup
    @controller = MediaSearchesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:media_searches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_media_search
    old_count = MediaSearch.count
    post :create, :media_search => { }
    assert_equal old_count+1, MediaSearch.count
    
    assert_redirected_to media_search_path(assigns(:media_search))
  end

  def test_should_show_media_search
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_media_search
    put :update, :id => 1, :media_search => { }
    assert_redirected_to media_search_path(assigns(:media_search))
  end
  
  def test_should_destroy_media_search
    old_count = MediaSearch.count
    delete :destroy, :id => 1
    assert_equal old_count-1, MediaSearch.count
    
    assert_redirected_to media_searches_path
  end
end
