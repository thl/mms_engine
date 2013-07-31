require 'test_helper'

class OnlineResourcesControllerTest < ActionController::TestCase
  setup do
    @online_resource = online_resources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:online_resources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create online_resource" do
    assert_difference('OnlineResource.count') do
      post :create, :online_resource => {  }
    end

    assert_redirected_to online_resource_path(assigns(:online_resource))
  end

  test "should show online_resource" do
    get :show, :id => @online_resource
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @online_resource
    assert_response :success
  end

  test "should update online_resource" do
    put :update, :id => @online_resource, :online_resource => {  }
    assert_redirected_to online_resource_path(assigns(:online_resource))
  end

  test "should destroy online_resource" do
    assert_difference('OnlineResource.count', -1) do
      delete :destroy, :id => @online_resource
    end

    assert_redirected_to online_resources_path
  end
end
