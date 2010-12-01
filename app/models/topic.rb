class Topic < Category
  headers['Host'] = TopicalMapResource.headers['Host'] if !TopicalMapResource.headers['Host'].blank?
  
  self.element_name = 'category'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id}, :joins => :media_category_associations, :limit => limit, :offset => offset, :order => 'media.created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :media_category_associations, :limit => limit, :offset => offset, :order => 'media.created_on DESC')
    end
    media
  end
  
  def media(options = {})
    type = options[:type]
    joins = options[:cumulative] ? :cumulative_media_category_associations : :media_category_associations
    conditions = {"#{joins.to_s}.category_id" => self.id}
    conditions['media.type'] = type if !type.nil?
    Medium.find(:all, :conditions => conditions, :joins => joins, :order => 'media.created_on DESC')
  end
    
  def media_count(type = nil)
    CachedCategoryCount.updated_count(self.id, type, force_update = false).count
  end
  
  def self.roots_with_media
    self.roots.select{ |topic| topic.media_count>0 }
  end

  alias count_inherited_media media_count
  # This helps with calls to count media for generalized elements
  # alias :media_count :count_inherited_media
end