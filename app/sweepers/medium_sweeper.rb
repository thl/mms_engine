class MediumSweeper < ActionController::Caching::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Medium
  FORMATS = ['xml', 'json']
  
  def after_save(medium)
    expire_cache(medium)
  end
  
  def after_destroy(medium)
    expire_cache(medium)
  end
  
  def expire_cache(medium)
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      paths = [medium_url(medium, options), media_url(options)]
      paths << document_url(medium, options) if medium.instance_of? Document
      paths.each{ |path| expire_page path }
    end
  end
end