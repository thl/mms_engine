require 'test_helper'

class MetadataSourcesControllerTest < ActionController::TestCase
  setup do
    @metadata_source = metadata_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metadata_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metadata_source" do
    assert_difference('MetadataSource.count') do
      post :create, :metadata_source => { :filename => @metadata_source.filename }
    end

    assert_redirected_to metadata_source_path(assigns(:metadata_source))
  end

  test "should show metadata_source" do
    get :show, :id => @metadata_source
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @metadata_source
    assert_response :success
  end

  test "should update metadata_source" do
    put :update, :id => @metadata_source, :metadata_source => { :filename => @metadata_source.filename }
    assert_redirected_to metadata_source_path(assigns(:metadata_source))
  end

  test "should destroy metadata_source" do
    assert_difference('MetadataSource.count', -1) do
      delete :destroy, :id => @metadata_source
    end

    assert_redirected_to metadata_sources_path
  end
end
