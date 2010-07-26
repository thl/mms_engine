class Place < Feature
  headers['Host'] = Category.headers['Host'] if !Category.headers['Host'].blank?
  
  self.element_name = 'feature'
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'locations.feature_id' => self.fid}, :joins => :locations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'locations.feature_id' => self.fid, 'media.type' => type}, :joins => :locations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    end
    media
  end
end