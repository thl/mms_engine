require File.dirname(__FILE__) + '/../test_helper'
require 'media_administrative_locations_controller'

# Re-raise errors caught by the controller.
class MediaAdministrativeLocationsController; def rescue_action(e) raise e end; end

class MediaAdministrativeLocationsControllerTest < Test::Unit::TestCase
  fixtures :media_administrative_locations

  def setup
    @controller = MediaAdministrativeLocationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:media_administrative_locations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_media_administrative_location
    old_count = MediaAdministrativeLocation.count
    post :create, :media_administrative_location => { }
    assert_equal old_count+1, MediaAdministrativeLocation.count
    
    assert_redirected_to media_administrative_location_path(assigns(:media_administrative_location))
  end

  def test_should_show_media_administrative_location
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_media_administrative_location
    put :update, :id => 1, :media_administrative_location => { }
    assert_redirected_to media_administrative_location_path(assigns(:media_administrative_location))
  end
  
  def test_should_destroy_media_administrative_location
    old_count = MediaAdministrativeLocation.count
    delete :destroy, :id => 1
    assert_equal old_count-1, MediaAdministrativeLocation.count
    
    assert_redirected_to media_administrative_locations_path
  end
end
