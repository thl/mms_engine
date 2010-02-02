require File.dirname(__FILE__) + '/../test_helper'
require 'people_controller'

# Re-raise errors caught by the controller.
class PeopleController; def rescue_action(e) raise e end; end

class PeopleControllerTest < Test::Unit::TestCase
  fixtures :people

  def setup
    @controller = PeopleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:people)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_person
    old_count = Person.count
    post :create, :person => { }
    assert_equal old_count+1, Person.count
    
    assert_redirected_to person_path(assigns(:person))
  end

  def test_should_show_person
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_person
    put :update, :id => 1, :person => { }
    assert_redirected_to person_path(assigns(:person))
  end
  
  def test_should_destroy_person
    old_count = Person.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Person.count
    
    assert_redirected_to people_path
  end
end
