class MediaCategoryAssociationSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe MediaCategoryAssociation
  
  def before_save(cf)
    expire_topic_cache(cf.category_id_was) if cf.category_id_changed? && !cf.category_id_was.nil?
  end
  
  def after_save(cf)
    expire_topic_cache(cf.category_id)
    expire_media_cache(cf.medium)
  end
  
  def after_destroy(cf)
    expire_topic_cache(cf.category_id)
    expire_media_cache(cf.medium)
  end
  
  def expire_topic_cache(c)
    expire_full_path_page category_counts_url(c, only_path: true, :format => :xml)
    actions = [{:controller => 'topics', :action => 'index'}]
    actions << ([c] + Topic.find(c).ancestors.collect(&:id)).inject([]){ |actions, c_id| actions + ['show', 'pictures', 'videos', 'documents'].collect{ |action| {:controller => 'topics', :action => action, :id => c_id} } } if !c.nil?
    actions.each{ |action| expire_fragment action }
  end
  
  def expire_media_cache(m)
    return if m.nil?
    options = {:only_path => true, :format => :xml}
    paths = [medium_url(m, options), media_url(options)]
    paths << document_url(m, options) if m.instance_of? Document
    paths.each{ |path| expire_full_path_page(path) }
  end
end