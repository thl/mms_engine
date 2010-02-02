require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerTest < Test::Unit::TestCase
  fixtures :documents

  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:documents)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_document
    old_count = Document.count
    post :create, :document => { }
    assert_equal old_count+1, Document.count
    
    assert_redirected_to document_path(assigns(:document))
  end

  def test_should_show_document
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_document
    put :update, :id => 1, :document => { }
    assert_redirected_to document_path(assigns(:document))
  end
  
  def test_should_destroy_document
    old_count = Document.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Document.count
    
    assert_redirected_to documents_path
  end
end
