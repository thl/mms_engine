class WorkflowSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Workflow
  
  def after_save(workflow)
    expire_cache(workflow)
  end
  
  def after_destroy(workflow)
    expire_cache(workflow)
  end
  
  def expire_cache(workflow)
    expire_full_path_page medium_workflow_url(workflow.medium, :only_path => true, :format => :xml)
  end
end
  