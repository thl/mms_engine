require_relative '../test_helper'

class MediaImportsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:media_imports)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_media_import
    assert_difference('MediaImport.count') do
      post :create, :media_import => { }
    end

    assert_redirected_to media_import_path(assigns(:media_import))
  end

  def test_should_show_media_import
    get :show, :id => media_imports(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => media_imports(:one).id
    assert_response :success
  end

  def test_should_update_media_import
    put :update, :id => media_imports(:one).id, :media_import => { }
    assert_redirected_to media_import_path(assigns(:media_import))
  end

  def test_should_destroy_media_import
    assert_difference('MediaImport.count', -1) do
      delete :destroy, :id => media_imports(:one).id
    end

    assert_redirected_to media_imports_path
  end
end
