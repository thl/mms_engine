#require 'document'

class DocumentSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Document
  
  def after_save(document)
    expire_cache(document)
  end
  
  def after_destroy(document)
    expire_cache(document)
  end
  
  def expire_cache(document)
    options = {:only_path => true, :format => :xml}
    [document_url(document, options), medium_url(document, options), media_url(options)].each{ |path| expire_full_path_page path }
  end
end
