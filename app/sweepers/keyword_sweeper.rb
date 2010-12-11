class KeywordSweeper < ActionController::Caching::Sweeper
  observe Keyword
  
  def after_save(k)
    expire_keywords_cache
  end
  
  def after_destroy(k)
    expire_keywords_cache
  end
  
  def expire_keywords_cache
    expire_fragment :controller => 'media', :action => 'index', :action_suffix => 'main'
  end  
end