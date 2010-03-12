require 'test_helper'

class TranslatedTitlesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:translated_titles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create translated_title" do
    assert_difference('TranslatedTitle.count') do
      post :create, :translated_title => { }
    end

    assert_redirected_to translated_title_path(assigns(:translated_title))
  end

  test "should show translated_title" do
    get :show, :id => translated_titles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => translated_titles(:one).to_param
    assert_response :success
  end

  test "should update translated_title" do
    put :update, :id => translated_titles(:one).to_param, :translated_title => { }
    assert_redirected_to translated_title_path(assigns(:translated_title))
  end

  test "should destroy translated_title" do
    assert_difference('TranslatedTitle.count', -1) do
      delete :destroy, :id => translated_titles(:one).to_param
    end

    assert_redirected_to translated_titles_path
  end
end
