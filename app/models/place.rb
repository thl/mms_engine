class Place < Feature
  headers['Host'] = PlacesResource.headers['Host'] if !PlacesResource.headers['Host'].blank?
  
  self.element_name = 'feature'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.where('locations.feature_id' => self.fid).joins(:locations).limit(limit).offset(offset).order('media.created_on DESC')
    else
      media = Medium.where('locations.feature_id' => self.fid, 'media.type' => type).joins(:locations).limit(limit).offset(offset).order('media.created_on DESC')
    end
    media
  end
    
  def title
    self.header
  end
  
  def media(options = {})
    type = options[:type]
    conditions = {'locations.feature_id' => self.fid}
    conditions['media.type'] = type if !type.nil?
    Medium.where(conditions).joins(:locations).order('media.created_on DESC')
  end
    
  def media_count(type = nil)
    if type.nil?
      count = Location.where('locations.feature_id' => self.fid).count
    else
      count = Location.where('locations.feature_id' => self.fid, 'media.type' => type).joins(:medium).count
    end
    count
  end
  
  # This helps with calls to count media for generalized elements
  # alias :media_count :count_inherited_media
  
  def title
    self.header
  end
  
  alias count_inherited_media media_count
end