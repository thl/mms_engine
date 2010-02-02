# MetadataImportation
require 'config/environment'

module MetadataImportation
  def self.do_metadata_importation(filename)
    field_names = nil
    english = ComplexScripts::Language.find_by_code('eng')
    CSV.open(filename, 'r', "\t") do |row|
      if field_names.nil?
        field_names = row
        next
      end
      fields = Hash.new
      row.each_with_index { |field, index| fields[field_names[index]] = field if !field.blank? }
      original_filename = fields['workflows.original_filename']
      workflow = Workflow.find(:first, :conditions => ['original_filename LIKE ?', '%s.%' % original_filename])
      if workflow.nil?
        puts "Media with original filename #{original_filename} not found!"
        next
      end
      workflow_updated = false
      original_medium_id = fields['workflows.original_medium_id']
      if !original_medium_id.blank? && workflow.original_medium_id.blank?
        workflow.original_medium_id = original_medium_id
        workflow_updated = true
      end
      other_id = fields['workflows.other_id']
      if !other_id.blank? && workflow.other_id.blank?
        workflow.other_id = other_id
        workflow_updated = true
      end
      sequence_order = fields['workflows.sequence_order']
      if !sequence_order.blank? && workflow.sequence_order.blank?
        workflow.sequence_order = sequence_order
        workflow_updated = true
      end  
      workflow_notes = fields['workflows.notes']
      if !workflow_notes.blank? && workflow.notes.blank?
        workflow.notes = workflow_notes
        workflow_updated = true
      end  
      workflow.save if workflow_updated
      medium = workflow.medium
      medium_updated = false
      recording_note = fields['media.recording_note']
      if !recording_note.nil?
        recording_note.strip!
        if !recording_note.empty? && medium.recording_note.blank?
          medium.recording_note = recording_note
          medium_updated = true
        end
      end
      private_note = fields['media.private_note']
      if !private_note.nil?
        private_note.strip!
        if !private_note.empty? && medium.private_note.blank?
          medium.private_note = private_note
          medium_updated = true
        end
      end
      taken_on_str = fields['media.taken_on']
      if !taken_on_str.blank?
        taken_on_str.strip!
        if !taken_on_str.blank?
          if medium.taken_on.nil?
            begin
              taken_on = DateTime.parse(taken_on_str)
            rescue
              if medium.partial_taken_on.blank?
                medium.partial_taken_on = taken_on_str
                medium_updated = true
              end
            else
              medium.taken_on = taken_on
              medium_updated = true
            end
          else
            begin
              taken_on = DateTime.parse(taken_on_str)
            rescue
              if medium.partial_taken_on.blank?
                medium.partial_taken_on = taken_on_str
                medium_updated = true
              end
            else
              if medium.taken_on != taken_on
                medium.partial_taken_on = taken_on_str
                medium_updated = true
              end
            end
          end
        end
      end
      photographer_str = fields['media.photographer']
      if !photographer_str.blank? && medium.photographer.nil?
        photographer_str.strip!
        if !photographer_str.empty?
          photographer = Person.find_by_fullname(photographer_str)
          if photographer.nil?
            puts "Photographer named #{photographer_str} not found!"
          else
            medium.photographer = photographer
            medium_updated = true
          end
        end
      end
      orientation_str = fields['recording_orientations.title']
      if !orientation_str.blank? && medium.recording_orientation.nil?
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
            medium.recording_orientation = orientation
            medium_updated = true
          end
        end
      end
      medium.save if medium_updated
      caption_str = fields['captions.title']
      if !caption_str.nil?
        caption_str.strip!
        if !caption_str.empty?
          caption = self.truncated_find(Caption, caption_str)
          captions = medium.captions
          if caption.nil?
            captions.create(:title => caption_str, :language => english)
          else
            captions << caption if !captions.collect{ |c| c.id }.include?(caption.id)
          end
        end
      end
      collection_str = fields['collections.title']
      if !collection_str.nil?
        collection_str.strip!
        if !collection_str.empty?
          begin
            collection = Collection.find_by_title(collection_str)
          rescue
            collection = nil
          end
          if collection.nil?
            puts "Collection #{collection_str} not found!"
          else
            begin
              collections = medium.collections
            rescue
              puts "Having issues with collections associated to Medium ID #{medium.id}!"
            else
              collections << collection if !collections.collect{|c| c.id}.include?(collection.id)
            end
          end
        end
      end
      unit_str = fields['administrative_units.title']
      if !unit_str.nil?
        unit_str.strip!
        if !unit_str.empty?
          unit = AdministrativeUnit.find_by_title(unit_str)
          if unit.nil?
            puts "Administrative unit #{unit_str} not found!"
          else
            location_note = fields['media_administrative_locations.notes']
            spot = fields['media_administrative_locations.spot_feature']
            if !location_note.nil?
              location_note.strip!
              location_note = nil if location_note.empty?
            end
            if !spot.nil?
              spot.strip!
              spot = nil if spot.empty?
            end
            location = MediaAdministrativeLocation.find(:first, :conditions => {:medium_id => medium.id, :administrative_unit_id => unit.id})
            if location.nil?
              location = MediaAdministrativeLocation.create(:medium => medium, :administrative_unit => unit, :spot_feature => spot, :notes => location_note)
            else
              location.spot_feature = spot if !spot.nil? && location.spot_feature.blank?
              location.notes = location_note if !location_note.nil? && location.notes.blank?
              location.save
            end
          end
        end
      end
      description_str = fields['descriptions.title']
      if !description_str.nil?
        description_str.strip!
        if !description_str.empty?
          description_creator_str = fields['descriptions.creator']
          description_creator = nil
          if !description_creator_str.nil?
            description_creator_str.strip!
            if !description_creator_str.empty?
              description_creator = Person.find_by_fullname(description_creator_str)
              if description_creator.nil?
                puts "Description creator named #{description_creator_str} not found!"
              end
            end
          end
          description = self.truncated_find(Description, description_str)
          descriptions = medium.descriptions
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
      keywords_str = fields['keywords.title']
      if !keywords_str.nil?
        keywords_str.strip!
        if !keywords_str.blank?
          keywords_array = keywords_str.split(',')
          keywords = medium.keywords
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
      source_str = fields['sources.title']
      if !source_str.nil?
        source_str.strip!
        if !source_str.blank?
          source = Source.find_by_title(source_str)
          if source.nil?
            puts "Source #{source_str} not found!"
          else
            shot = fields['media_source_associations.shot_number']
            if !shot.nil?
              shot.strip!
              shot = nil if shot.empty?
            end
            source_association = MediaSourceAssociation.find(:first, :conditions => {:medium_id => medium.id, :source_id => source.id})
            if source_association.nil?
              source_association = MediaSourceAssociation.create(:medium => medium, :source => source, :shot_number => shot)
            else
              source_association.shot_number = shot.to_i if !shot.nil? && source_association.shot_number.nil?
              source_association.save
            end
          end
        end
      end
    end
  end
  
  def self.truncated_find(model, str)
    return str.size<=200 ? model.find_by_title(str) : model.find(:first, :conditions => ['LEFT(title, 100) = ?', str[0...200]])
  end
end