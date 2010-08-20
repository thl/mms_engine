class CachedCategoryCountSweeper < ActiveRecord::Observer
  observe Location
  
  def before_save(l)
    expire_cache(l.feature_id_was) if l.feature_id_changed?
  end
  
  def after_save(l)
    expire_cache(l.feature_id)
  end
  
  def after_destroy(l)
    expire_cache(l.feature_id)
  end
  
  def expire_cache(f)
    ApplicationController.expire_page("/places/#{f}/counts.xml") if !f.nil?
  end
end