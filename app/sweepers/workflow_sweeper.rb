class WorkflowSweeper < ActionController::Caching::Sweeper
  observe Workflow
  
  def after_save(workflow)
    expire_cache(workflow)
  end
  
  def after_destroy(workflow)
    expire_cache(workflow)
  end
  
  def expire_cache(workflow)
    expire_page medium_workflow_url(workflow.medium, :skip_relative_url_root => true, :only_path => true, :format => :xml)
  end
end
  