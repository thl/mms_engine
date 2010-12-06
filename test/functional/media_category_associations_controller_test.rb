require 'test_helper'

class MediaCategoryAssociationsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_category_associations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_category_association" do
    assert_difference('MediaCategoryAssociation.count') do
      post :create, :media_category_association => { }
    end

    assert_redirected_to media_category_association_path(assigns(:media_category_association))
  end

  test "should show media_category_association" do
    get :show, :id => media_category_associations(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => media_category_associations(:one).to_param
    assert_response :success
  end

  test "should update media_category_association" do
    put :update, :id => media_category_associations(:one).to_param, :media_category_association => { }
    assert_redirected_to media_category_association_path(assigns(:media_category_association))
  end

  test "should destroy media_category_association" do
    assert_difference('MediaCategoryAssociation.count', -1) do
      delete :destroy, :id => media_category_associations(:one).to_param
    end

    assert_redirected_to media_category_associations_path
  end
end
