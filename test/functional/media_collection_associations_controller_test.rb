require 'test_helper'

class MediaCollectionAssociationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:media_collection_associations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media_collection_association
    assert_difference('MediaCollectionAssociation.count') do
      post :create, :media_collection_association => { }
    end

    assert_redirected_to media_collection_association_path(assigns(:media_collection_association))
  end

  def test_should_show_media_collection_association
    get :show, :id => media_collection_associations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => media_collection_associations(:one).id
    assert_response :success
  end

  def test_should_update_media_collection_association
    put :update, :id => media_collection_associations(:one).id, :media_collection_association => { }
    assert_redirected_to media_collection_association_path(assigns(:media_collection_association))
  end

  def test_should_destroy_media_collection_association
    assert_difference('MediaCollectionAssociation.count', -1) do
      delete :destroy, :id => media_collection_associations(:one).id
    end

    assert_redirected_to media_collection_associations_path
  end
end
