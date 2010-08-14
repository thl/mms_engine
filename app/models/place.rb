class Place < Feature
  headers['Host'] = PlacesResource.headers['Host'] if !PlacesResource.headers['Host'].blank?
  
  self.element_name = 'feature'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'locations.feature_id' => self.fid}, :joins => :locations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'locations.feature_id' => self.fid, 'media.type' => type}, :joins => :locations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    end
    media
  end
  
  def count_inherited_media(type = nil)
    if type.nil?
      media_count = Medium.count('media.id', :distinct => true, :conditions => {'locations.feature_id' => self.fid}, :joins => :locations)
    else
      media_count = Medium.count('media.id', :distinct => true, :conditions => {'locations.feature_id' => self.fid, 'media.type' => type}, :joins => :locations)
    end
    media_count
  end
  
  # This helps with calls to count media for generalized elements
  alias :count_media :count_inherited_media
  
  def title
    self.header
  end
end