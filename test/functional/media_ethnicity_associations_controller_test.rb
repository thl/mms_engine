require File.dirname(__FILE__) + '/../test_helper'
require 'media_ethnicity_associations_controller'

# Re-raise errors caught by the controller.
class MediaEthnicityAssociationsController; def rescue_action(e) raise e end; end

class MediaEthnicityAssociationsControllerTest < Test::Unit::TestCase
  fixtures :media_ethnicity_associations

  def setup
    @controller = MediaEthnicityAssociationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:media_ethnicity_associations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_media_ethnicity_association
    old_count = MediaEthnicityAssociation.count
    post :create, :media_ethnicity_association => { }
    assert_equal old_count+1, MediaEthnicityAssociation.count
    
    assert_redirected_to media_ethnicity_association_path(assigns(:media_ethnicity_association))
  end

  def test_should_show_media_ethnicity_association
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_media_ethnicity_association
    put :update, :id => 1, :media_ethnicity_association => { }
    assert_redirected_to media_ethnicity_association_path(assigns(:media_ethnicity_association))
  end
  
  def test_should_destroy_media_ethnicity_association
    old_count = MediaEthnicityAssociation.count
    delete :destroy, :id => 1
    assert_equal old_count-1, MediaEthnicityAssociation.count
    
    assert_redirected_to media_ethnicity_associations_path
  end
end
