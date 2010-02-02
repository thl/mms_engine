require File.dirname(__FILE__) + '/../test_helper'
require 'dictionary_searches_controller'

# Re-raise errors caught by the controller.
class DictionarySearchesController; def rescue_action(e) raise e end; end

class DictionarySearchesControllerTest < Test::Unit::TestCase
  fixtures :dictionarySearches

  def setup
    @controller = DictionarySearchesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:searches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_dictionary_search
    old_count = DictionarySearch.count
    post :create, :dictionarySearch => { }
    assert_equal old_count+1, DictionarySearch.count
    
    assert_redirected_to dictionary_search_path(assigns(:dictionarySearch))
  end

  def test_should_show_dictionary_search
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_dictionary_search
    put :update, :id => 1, :dictionarySearch => { }
    assert_redirected_to search_path(assigns(:dictionarySearch))
  end
  
  def test_should_destroy_dictionary_search
    old_count = DictionarySearch.count
    delete :destroy, :id => 1
    assert_equal old_count-1, DictionarySearch.count
    
    assert_redirected_to dictionary_searches_path
  end
end
