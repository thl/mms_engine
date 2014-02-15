require_relative '../test_helper'
require 'glossaries_controller'

# Re-raise errors caught by the controller.
class GlossariesController; def rescue_action(e) raise e end; end

class GlossariesControllerTest < Test::Unit::TestCase
  fixtures :glossaries

  def setup
    @controller = GlossariesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:glossaries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_glossary
    old_count = Glossary.count
    post :create, :glossary => { }
    assert_equal old_count+1, Glossary.count
    
    assert_redirected_to glossary_path(assigns(:glossary))
  end

  def test_should_show_glossary
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_glossary
    put :update, :id => 1, :glossary => { }
    assert_redirected_to glossary_path(assigns(:glossary))
  end
  
  def test_should_destroy_glossary
    old_count = Glossary.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Glossary.count
    
    assert_redirected_to glossaries_path
  end
end
