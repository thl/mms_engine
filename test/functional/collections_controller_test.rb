require 'test_helper'

class CollectionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:collections)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_collection
    assert_difference('Collection.count') do
      post :create, :collection => { }
    end

    assert_redirected_to collection_path(assigns(:collection))
  end

  def test_should_show_collection
    get :show, :id => collections(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => collections(:one).id
    assert_response :success
  end

  def test_should_update_collection
    put :update, :id => collections(:one).id, :collection => { }
    assert_redirected_to collection_path(assigns(:collection))
  end

  def test_should_destroy_collection
    assert_difference('Collection.count', -1) do
      delete :destroy, :id => collections(:one).id
    end

    assert_redirected_to collections_path
  end
end
