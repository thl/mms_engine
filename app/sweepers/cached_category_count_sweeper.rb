class CachedCategoryCountSweeper < ActiveRecord::Observer
  observe MediaCategoryAssociation
  
  def before_save(cf)
    expire_cache(cf.category_id_was) if cf.category_id_changed?
  end
  
  def after_save(cf)
    expire_cache(cf.category_id)
  end
  
  def after_destroy(cf)
    expire_cache(cf.category_id)
  end
  
  def expire_cache(c)
    ApplicationController.expire_page("/categories/#{c}/counts.xml") if !c.nil?
  end
end