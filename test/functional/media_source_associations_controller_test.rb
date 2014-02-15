require_relative '../test_helper'

class MediaSourceAssociationsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:media_source_associations)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media_source_association
    assert_difference('MediaSourceAssociation.count') do
      post :create, :media_source_association => { }
    end

    assert_redirected_to media_source_association_path(assigns(:media_source_association))
  end

  def test_should_show_media_source_association
    get :show, :id => media_source_associations(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => media_source_associations(:one).id
    assert_response :success
  end

  def test_should_update_media_source_association
    put :update, :id => media_source_associations(:one).id, :media_source_association => { }
    assert_redirected_to media_source_association_path(assigns(:media_source_association))
  end

  def test_should_destroy_media_source_association
    assert_difference('MediaSourceAssociation.count', -1) do
      delete :destroy, :id => media_source_associations(:one).id
    end

    assert_redirected_to media_source_associations_path
  end
end
