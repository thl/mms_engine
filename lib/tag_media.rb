# TagMedia
# require 'config/environment'

module TagMedia
  def self.tag_media(media_id_start, media_id_end, copyright_holder_id, reproduction_type_id, collection_id, organization_id = nil)
    media = Medium.find(:all, :conditions => ['id >= ? AND id <= ?', media_id_start, media_id_end])
    
    if !copyright_holder_id.blank?
      copyright_holder = CopyrightHolder.find(copyright_holder_id)
      if !copyright_holder.nil?
        reproduction_type = ReproductionType.find(reproduction_type_id)
      end
    end

    if !collection_id.blank?
      collection = Collection.find(collection_id)
    end
    
    if !organization_id.blank?
      organization = Organization.find(organization_id)
    end
        
    for medium in media
      if !copyright_holder.nil?
        copyright = Copyright.find :first, :conditions => {:medium_id => medium, :copyright_holder_id => copyright_holder}
        Copyright.create :medium => medium, :copyrightHolder => copyright_holder, :reproductionType => reproduction_type if copyright.nil?
      end
      if !collection.nil?
        media_collection_association = MediaCollectionAssociation.find :first, :conditions => {:medium_id => medium, :collection_id => collection}
        MediaCollectionAssociation.create :medium => medium, :collection => collection if media_collection_association.nil? 
      end
      if !organization.nil?
        affiliation = Affiliation.find :first, :conditions => {:medium_id => medium, :organization_id => organization}
        Affiliation.create :medium => medium, :organization => organization if affiliation.nil?
      end
    end    
  end
  
  def self.match_date_with_topics(topic_ids)
    topics = topic_ids.split(/\D+/).reject(&:blank?).collect{ |id| Topic.find(id.to_i) }.reject(&:nil?)
    topics.each do |t|
      year = t.title.split(/\D+/).find{|id| !id.blank? && id.size==4}
      t.media(:type => 'Picture').each{|p| Picture.find(p.id).update_taken_on(year)} if !year.nil?
    end
  end
  
  def self.tag_current_media
    # collection_id, organization_id
    tag_media(1, 386, 2, 4, 4, 2)
    # ILCS videos: 387 - 391
    tag_media(387, 391, 3, 4, 7, 1)
    # ILCS ritual pictures: 392 - 978
    tag_media(392, 978, 3, 4, 7, 1)
    # ILCS scenic pictures: 979 - 1054
    tag_media(979, 1054, 3, 4, 7, 1)
    # Francoise's pics: 1055 - 1545 
    tag_media(1055, 1545, 1, 4, 8)
  end
end
