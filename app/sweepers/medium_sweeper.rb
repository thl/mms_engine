class MediumSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  include ActionController::Caching::Actions
  
  observe Medium, Location, MediaCategoryAssociation
  FORMATS = ['xml', 'json']
  RELATIVE_ROOT = ActionController::Base.relative_url_root
  
  def after_save(record)
    expire_cache(record)
  end
  
  def after_destroy(record)
    expire_cache(record)
  end
  
  def expire_cache(record)
    if record.kind_of? Medium
      medium = record
    else
      medium = record.medium
    end
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      paths = [medium_url(medium, options), media_url(options)]
      paths << document_url(medium, options) if medium.instance_of? Document
      paths.each{ |path| expire_full_path_page path }
    end
    options[:format] = 'html'
    expire_action "#{RELATIVE_ROOT if !RELATIVE_ROOT.blank?}#{external_medium_url(medium, options)}"
  end
end