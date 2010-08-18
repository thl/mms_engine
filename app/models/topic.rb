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
  
  def media(type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id}, :joins => :media_category_associations, :order => 'media.created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :media_category_associations, :order => 'media.created_on DESC')
    end
    media
  end
    
  def media_count(type = nil)
    if type.nil?
      count = MediaCategoryAssociation.count(:conditions => {:category_id => self.id})
    else
      count = MediaCategoryAssociation.count(:conditions => {:category_id => self.id, 'media.type' => type}, :joins => :medium)
    end
  end
  alias count_inherited_media media_count
end