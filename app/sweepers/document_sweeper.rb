#require 'document'

class DocumentSweeper < ActionController::Caching::Sweeper
  observe Document
  
  def after_save(document)
    expire_cache(document)
  end
  
  def after_destroy(document)
    expire_cache(document)
  end
  
  def expire_cache(document)
    options = {:only_path => true, :format => :xml}
    [document_url(document, options), medium_url(document, options)].each{ |path| expire_page path }
  end
end
