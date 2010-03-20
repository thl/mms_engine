require 'test_helper'

class ApplicationFiltersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filter" do
    assert_difference('Filter.count') do
      post :create, :filter => { }
    end

    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should show filter" do
    get :show, :id => filters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => filters(:one).to_param
    assert_response :success
  end

  test "should update filter" do
    put :update, :id => filters(:one).to_param, :filter => { }
    assert_redirected_to filter_path(assigns(:filter))
  end

  test "should destroy filter" do
    assert_difference('Filter.count', -1) do
      delete :destroy, :id => filters(:one).to_param
    end

    assert_redirected_to filters_path
  end
end
