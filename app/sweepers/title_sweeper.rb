class TitleSweeper < ActionController::Caching::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Title
  
  def after_save(title)
    expire_cache(title)
  end
  
  def after_destroy(title)
    expire_cache(title)
  end
  
  def expire_cache(title)
    options = {:only_path => true, :format => :xml}
    medium = title.medium
    paths = [medium_titles_url(medium, options), medium_title_url(medium, title, options), medium_url(medium, options), media_url(options)]
    paths << document_url(medium, options) if medium.instance_of? Document
    paths.each {|path| expire_page path}
  end
  
  private
  
  # Very weird! ActionController::Caching seems to assume it is being called from controller. Adding this as hack
  def self.perform_caching
    Rails.configuration.action_controller.perform_caching
  end
end
