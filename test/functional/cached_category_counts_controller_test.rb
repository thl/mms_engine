require 'test_helper'

class CachedCategoryCountsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:cached_category_counts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_cached_category_count
    assert_difference('CachedCategoryCount.count') do
      post :create, :cached_category_count => { }
    end

    assert_redirected_to cached_category_count_path(assigns(:cached_category_count))
  end

  def test_should_show_cached_category_count
    get :show, :id => cached_category_counts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => cached_category_counts(:one).id
    assert_response :success
  end

  def test_should_update_cached_category_count
    put :update, :id => cached_category_counts(:one).id, :cached_category_count => { }
    assert_redirected_to cached_category_count_path(assigns(:cached_category_count))
  end

  def test_should_destroy_cached_category_count
    assert_difference('CachedCategoryCount.count', -1) do
      delete :destroy, :id => cached_category_counts(:one).id
    end

    assert_redirected_to cached_category_counts_path
  end
end
