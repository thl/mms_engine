class Place < PlacesIntegration::Feature
  headers['Host'] = PlacesIntegration::PlacesResource.headers['Host'] if !PlacesIntegration::PlacesResource.headers['Host'].blank?
  
  self.element_name = 'feature'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.where('cumulative_media_location_associations.feature_id' => self.fid).joins(:cumulative_media_location_associations).limit(limit).offset(offset).order('media.created_on DESC')
    else
      media = Medium.where('cumulative_media_location_associations.feature_id' => self.fid, 'media.type' => type).joins(:cumulative_media_location_associations).limit(limit).offset(offset).order('media.created_on DESC')
    end
    media
  end
    
  def title
    self.header
  end
  
  def media(options = {})
    type = options[:type]
    conditions = {'cumulative_media_location_associations.feature_id' => self.fid}
    conditions['media.type'] = type if !type.nil?
    Medium.where(conditions).joins(:cumulative_media_location_associations).order('media.created_on DESC')
  end
    
  def media_count(type = nil)
    if type.nil?
      count = CumulativeMediaLocationAssociation.where(:feature_id => self.fid).count
    else
      count = CumulativeMediaLocationAssociation.where('cumulative_media_location_associations.feature_id' => self.fid, 'media.type' => type).joins(:medium).count
    end
    count
  end
  
  # This helps with calls to count media for generalized elements
  # alias :media_count :count_inherited_media
  
  def title
    self.header
  end
  
  def fid
    fid = self.attributes['fid']
    fid.nil? ? self.id : fid
  end
    
  alias count_inherited_media media_count
end