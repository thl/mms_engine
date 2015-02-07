class WorkflowSweeper < ActionController::Caching::Sweeper
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
    expire_page medium_workflow_url(workflow.medium, :only_path => true, :format => :xml)
  end
  
  private
  
  # Very weird! ActionController::Caching seems to assume it is being called from controller. Adding this as hack
  def self.perform_caching
    Rails.configuration.action_controller.perform_caching
  end
end
  