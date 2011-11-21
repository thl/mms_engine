# MetadataImportation
require 'config/environment'
require 'csv'

class MetadataImportation
  attr_accessor :medium, :workflow, :english, :topic_root_ids
    
  def get_medium
    medium_id = self.fields.delete('media.id')
    if medium_id.blank?
      original_filename = self.fields.delete('workflows.original_filename')
      if original_filename.blank?
      else
        workflow = Workflow.find(:first, :conditions => ['original_filename LIKE ?', '%s.%' % original_filename])
        if workflow.nil?
          puts "Media with original filename #{original_filename} not found!"
          return false
        else
          self.medium = workflow.medium
        end
      end
    else
      self.medium = Medium.find(medium_id)
      if self.medium.nil?
        puts "Medium with ID #{medium_id} not found!"
        return false
      end
    end
    return !self.medium.nil?
  end
  
  def process_workflow
    original_medium_id = self.fields.delete('workflows.original_medium_id')
    other_id = self.fields.delete('workflows.other_id')
    sequence_order = self.fields.delete('workflows.sequence_order')
    workflow_notes = self.fields.delete('workflows.notes')
    if !original_medium_id.blank? || !other_id.blank? || !sequence_order.blank? || !workflow_notes.blank?
      workflow = self.medium.workflow || self.medium.create_workflow
      workflow.original_medium_id = original_medium_id if !original_medium_id.blank? && workflow.original_medium_id.blank?
      workflow.other_id = other_id if !other_id.blank? && workflow.other_id.blank?
      workflow.sequence_order = sequence_order if !sequence_order.blank? && workflow.sequence_order.blank?
      workflow.notes = workflow_notes if !workflow_notes.blank? && workflow.notes.blank?
      workflow.save if workflow.changed?      
    end    
  end
  
  def process_media_core_fields
    recording_note = self.fields.delete('media.recording_note')
    private_note = self.fields.delete('media.private_note')
    taken_on_str = self.fields.delete('media.taken_on')
    if !taken_on_str.blank?
      taken_on_str.strip!
      if !taken_on_str.blank?
        begin
          # taken_on = DateTime.parse(taken_on_str)
          taken_on = Date.strptime(taken_on_str, '%d/%m/%Y')
        rescue
          self.medium.partial_taken_on = taken_on_str if self.medium.partial_taken_on.blank?
        else
          self.medium.taken_on = taken_on
        end
      end
    end
    photographer_str = self.fields.delete('media.photographer')
    if !photographer_str.blank? && self.medium.photographer.nil?
      photographer = Person.find_by_fullname(photographer_str)
      if photographer.nil?
        puts "Photographer named #{photographer_str} not found!"
      else
        self.medium.photographer = photographer
      end
    end
    orientation_str = self.fields.delete('recording_orientations.title')
    if !orientation_str.blank? && self.medium.recording_orientation.nil?
      orientation_str.strip!
      if !orientation_str.nil?
        begin
          orientation = RecordingOrientation.find_by_title(orientation_str)
        rescue
          orientation = nil
        end
        if orientation.nil?
          puts "Orientation #{orientation_str} not found!"
        else
          self.medium.recording_orientation = orientation
        end
      end
    end
    self.medium.save if self.medium.changed?
  end
  
  def process_caption
    caption_str = self.fields.delete('captions.title')
    if !caption_str.nil?
      caption = MetadataImportation.truncated_find(Caption, caption_str)
      captions = self.medium.captions
      if caption.nil?
        captions.create(:title => caption_str, :language => self.english)
      else
        captions << caption if !captions.collect{ |c| c.id }.include?(caption.id)
      end
    end
  end
  
  def process_topic
    topic_id = self.fields.delete('topics.id')
    topic_str = self.fields.delete('topics.title') if topic_id.blank?
    delete_topics = self.fields.delete('topics.delete')
    associations = self.medium.media_category_associations
    associations.clear if !delete_topics.blank? && delete_topics.downcase == 'yes'
    if !topic_id.blank? || !topic_str.blank?
      begin
        if topic_id.blank?
          topic = topic_str.blank? ? nil : Topic.find_by_title(topic_str)
        else
          topic = Topic.find(topic_id)
        end
      rescue
        topic = nil
      end
      if topic.nil?
        puts "Topic #{topic_str} not found!"
      else
        root_ids = self.topic_root_ids
        root_ids[topic.id] ||= topic.root.id
        associations.create(:category_id => topic.id, :root_id => root_ids[topic.id]) if !associations.collect{|a| a.category_id}.include?(topic.id)
      end
    end
  end
  
  def process_location
    feature_str = self.fields.delete('locations.feature_id')
    if feature_str.blank?
      geo_code_type = self.fields.delete('geo_code_types.code')
      geo_code = self.fields.delete('features.geo_code')
      if !geo_code_type.blank? && !geo_code.blank?
        feature = Feature.find_by_geo_code(geo_code_type, geo_code)
        puts "Place with geo code #{geo_code} not found!" if feature.nil?
      end
    else
      feature = Feature.find(feature_str)
      puts "Place with FID #{feature_str} not found!" if feature.nil?
    end
    if !feature.nil?
      location_note = self.fields.delete('locations.notes')
      spot = self.fields.delete('locations.spot_feature')
      lat = self.fields.delete('locations.lat')
      lng = self.fields.delete('locations.lng')
      location = Location.find(:first, :conditions => {:medium_id => medium.id, :feature_id => feature.fid})
      if location.nil?
        location = Location.create(:medium => medium, :feature_id => feature.fid, :spot_feature => spot, :notes => location_note, :lat => lat, :lng => lng)
      else
        location.spot_feature = spot if !spot.nil? && location.spot_feature.blank?
        location.notes = location_note if !location_note.nil? && location.notes.blank?
        location.lat = lat if !lat.nil? && location.lat.nil?
        location.lng = lng if !lng.nil? && location.lng.nil?
        location.save
      end      
    end
  end
  
  def process_description
    description_str = self.fields.delete('descriptions.title')
    if !description_str.nil?
      description_creator_str = self.fields.delete('descriptions.creator')
      description_creator = nil
      if !description_creator_str.nil?
        description_creator = Person.find_by_fullname(description_creator_str)
        if description_creator.nil?
          puts "Description creator named #{description_creator_str} not found!"
        end
      end
      description = MetadataImportation.truncated_find(Description, description_str)
      descriptions = self.medium.descriptions
      if description.nil?
        descriptions.create(:title => description_str, :language => english, :creator => description_creator)
      else
        if !description_creator.nil? && description.creator.nil?
          description.creator = description_creator
          description.save
        end
        descriptions << description if !descriptions.collect{ |d| d.id }.include?(description.id)
      end
    end
  end
  
  def process_keywords
    keywords_str = self.fields.delete('keywords.title')
    if !keywords_str.nil?
      keywords_str.strip!
      if !keywords_str.blank?
        keywords_array = keywords_str.split(',')
        keywords = self.medium.keywords
        keyword_ids = keywords.collect{|k| k.id}
        for keyword_str in keywords_array
          keyword = Keyword.find_by_title(keyword_str)
          if keyword.nil?
            puts "Keyword #{keyword_str} not found!"
          else
            keywords << keyword if !keyword_ids.include?(keyword.id)
          end
        end
      end
    end
  end
  
  def process_source
    source_str = self.fields.delete('sources.title')
    if !source_str.nil?
      source_str.strip!
      if !source_str.blank?
        source = Source.find_by_title(source_str)
        if source.nil?
          puts "Source #{source_str} not found!"
        else
          shot = self.fields.delete('media_source_associations.shot_number')
          source_association = MediaSourceAssociation.find(:first, :conditions => {:medium_id => self.medium.id, :source_id => source.id})
          if source_association.nil?
            source_association = MediaSourceAssociation.create(:medium => self.medium, :source => source, :shot_number => shot)
          else
            source_association.shot_number = shot.to_i if !shot.nil? && source_association.shot_number.nil?
            source_association.save
          end
        end
      end
    end
  end
  
  # Accepts:
  # media.id, workflows.original_filename
  # workflows.original_medium_id, workflows.other_id, workflows.sequence_order, workflows.notes
  # media.recording_note, media.private_note, media.taken_on, media.photographer, recording_orientations.title
  # locations.feature_id, geo_code_types.code, features.geo_code, locations.notes, locations.spot_feature
  # captions.title
  # topics.title | topics.id, topics.delete
  # descriptions.title, descriptions.creator
  # keywords.title
  # sources.title, media_source_associations.shot_number
  def do_metadata_importation(filename)
    self.english = ComplexScripts::Language.find_by_code('eng')
    self.topic_root_ids = Hash.new
    self.do_csv_import(filename) do
      next unless self.get_medium
      self.process_media_core_fields
      self.process_workflow
      self.process_caption
      self.process_topic
      self.process_location
      self.process_description
      self.process_keywords
      self.process_source
      if self.fields.empty?
        puts "#{self.medium.id} processed."
      else
        puts "#{self.medium.id}: the following fields have been ignored: #{self.fields.keys.join(', ')}"
      end      
    end
  end
  
  def self.truncated_find(model, str)
    return str.size<=200 ? model.find_by_title(str) : model.find(:first, :conditions => ['LEFT(title, 100) = ?', str[0...200]])
  end
end