class TitleSweeper < ActionController::Caching::Sweeper
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
end
