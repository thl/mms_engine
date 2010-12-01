class CachedCategoryCountSweeper < ActiveRecord::Observer
  observe MediaCategoryAssociation
  
  def before_save(cf)
    expire_count_cache(cf.category_id_was) if cf.category_id_changed?
  end
  
  def after_save(cf)
    expire_count_cache(cf.category_id)
    expire_media_cache(cf.medium)
  end
  
  def after_destroy(cf)
    expire_count_cache(cf.category_id)
    expire_media_cache(cf.medium)
  end
  
  def expire_count_cache(c)
    (["/categories/#{c}/counts.xml", '/topics.html'] + ([c] + Category.find(c).ancestors.collect(&:id)).inject([]){ |array, c| array + ["/topics/#{c}.html", "/topics/#{c}/pictures.html", "/topics/#{c}/videos.html", "/topics/#{c}/documents.html"]}).each{|path| ApplicationController.expire_page(path)} if !c.nil?
  end
  
  def expire_media_cache(m)
    return if m.nil?
    paths = ["/media_objects/#{m.id}.xml"]
    paths << "/documents/#{m.id}.xml" if m.instance_of? Document
    paths.each{ |path| ApplicationController.expire_page(path) }
  end
end