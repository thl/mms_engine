require File.dirname(__FILE__) + '/../test_helper'

class WorkflowsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:workflows)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_workflow
    assert_difference('Workflow.count') do
      post :create, :workflow => { }
    end

    assert_redirected_to workflow_path(assigns(:workflow))
  end

  def test_should_show_workflow
    get :show, :id => workflows(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => workflows(:one).id
    assert_response :success
  end

  def test_should_update_workflow
    put :update, :id => workflows(:one).id, :workflow => { }
    assert_redirected_to workflow_path(assigns(:workflow))
  end

  def test_should_destroy_workflow
    assert_difference('Workflow.count', -1) do
      delete :destroy, :id => workflows(:one).id
    end

    assert_redirected_to workflows_path
  end
end
