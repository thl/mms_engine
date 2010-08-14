class Topic < Feature
  headers['Host'] = TopicalMapResource.headers['Host'] if !TopicalMapResource.headers['Host'].blank?
  
  self.element_name = 'category'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id}, :joins => :media_category_associations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :media_category_associations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    end
    media
  end
  
  def count_inherited_media(type = nil)
    if type.nil?
      media_count = Medium.count('media.id', :distinct => true, :conditions => {'media_category_associations.category_id' => self.id}, :joins => :media_category_associations)
    else
      media_count = Medium.count('media.id', :distinct => true, :conditions => {'media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :media_category_associations)
    end
    media_count
  end

  # This helps with calls to count media for generalized elements
  alias :count_media :count_inherited_media
end