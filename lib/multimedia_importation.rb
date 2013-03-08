# ImportMedia
# require 'config/environment'

module MultimediaImportation
  include ForkedNotifier
  include FilenameUtils
  
  def assess_media_importation(source, type, check_existence, has_mediapro_metadata, *classifications)
    levels = Hash.new
    objects = Hash.new
    media = Array.new
    models = {'topic' => Topic } # 'place' => Place
    Dir.chdir(source) do
      Dir.glob('*').sort.each do |classification_title_0|
        next if !File.directory?(classification_title_0)
        #  raise "File <i>#{classification_title_0}</i> was found directly under #{source}. <i>Relative folder containing media to import</i> should include sub-folders which you specified (in classification scheme setting) to represent <i>#{classifications[0].pluralize}</i> with the media placed under them!"
        #end
        if classifications[0].blank?
          raise "First level folder found but no first level classification defined!"
        end
        objects[classifications[0]] = classifications[0]=='recording_note' ? classification_title_0 : models[classifications[0]].find_by_title(classification_title_0, true)
        if objects[classifications[0]].nil?
          raise "Could not find the <i>#{classifications[0]}</i> called <i>#{classification_title_0}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
        end
        levels[0] = classifications[0]
        Dir.chdir(classification_title_0) do
          Dir.glob('*').sort.each do |classification_title_1|
            if File.directory?(classification_title_1)
              if classifications[1].blank?
                raise "Second level folder <i>#{classification_title_1}</i> found but no second level classification defined!"
              end
              objects[classifications[1]] = classifications[1]=='recording_note' ? classification_title_1 : models[classifications[1]].find_by_title(classification_title_1, true)
              if objects[classifications[1]].nil?
                raise "Could not find the <i>#{classifications[1]}</i> called <i>#{classification_title_1}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
              end
              levels[1] = classifications[1]
              Dir.chdir(classification_title_1) do
                Dir.glob('*').sort.each do |classification_title_2|
                  if File.directory?(classification_title_2)
                    if classifications[2].blank?
                      raise "Third level folder <i>#{classification_title_2}</i> found but no third level classification defined!"
                    end
                    objects[classifications[2]] = classifications[2]=='recording_note' ? classification_title_2 : models[classifications[2]].find_by_title(classification_title_2, true)
                    if objects[classifications[2]].nil?
                      raise "Could not find the <i>#{classifications[2]}</i> called <i>#{classification_title_2}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
                    end                    
                    levels[2] = classifications[2]
                    Dir.chdir(classification_title_2) do
                      Dir.glob('*').sort.each do |classification_title_3|
                        if File.directory?(classification_title_3)
                          raise "Found fourth level folder <i>#{classification_title_3}</i> found but importation does not support fourth level classifications!"
                        elsif has_mediapro_metadata && FilenameUtils.extension_without_dot(classification_title_3).downcase=='xml'
                          assess_media_pro_xml_file(classification_title_3)
                          media << media_pro_xml_hash(classification_title_3, File.join(source, classification_title_0, classification_title_1, classification_title_2, classification_title_3))
                        elsif invalid_extension(classification_title_3, type)
                          next
                        else
                          classification = classifications.collect { |c| objects[c]  }
                          media << media_hash(type, classification, classification_title_3, File.join(source, classification_title_0, classification_title_1, classification_title_2, classification_title_3), check_existence)
                        end
                      end
                    end
                    objects[levels[2]] = nil
                  elsif has_mediapro_metadata && FilenameUtils.extension_without_dot(classification_title_2).downcase=='xml'
                    assess_media_pro_xml_file(classification_title_2)
                    media << media_pro_xml_hash(classification_title_2, File.join(source, classification_title_0, classification_title_1, classification_title_2))
                  elsif invalid_extension(classification_title_2, type)
                    next
                  else
                    classification = classifications[0..1].collect { |c| objects[c]  }
                    media << media_hash(type, classification, classification_title_2, File.join(source, classification_title_0, classification_title_1, classification_title_2), check_existence)
                  end
                end
              end
              objects[levels[1]] = nil
            elsif has_mediapro_metadata && FilenameUtils.extension_without_dot(classification_title_1).downcase=='xml'
              assess_media_pro_xml_file(classification_title_1)
              media << media_pro_xml_hash(classification_title_1, File.join(source, classification_title_0, classification_title_1))
            elsif invalid_extension(classification_title_1, type)
              next
            else
              classification = classifications[0..0].collect { |c| objects[c]  }
              media << media_hash(type, classification, classification_title_1, File.join(source, classification_title_0, classification_title_1), check_existence)
            end
          end
        end
        objects[levels[0]] = nil
      end
    end
    return media
  end
  
  def assess_media_pro_xml_file(file)
    doc = open(file) { |f| Hpricot(f) }
    ((doc/'author').collect(&:inner_text).uniq + (doc/'writer').collect(&:inner_text).uniq).reject(&:blank?).each{|s| raise "Could not find the person #{s} mentioned in #{file}! Please create it first." if AuthenticatedSystem::Person.find_by_fullname(s).nil? }
    (doc/'copyright').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the copyright holder #{s} mentioned in #{file}! Please create it first." if CopyrightHolder.find_by_title(s).nil? }
    (doc/'category').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the feature #{s} mentioned in #{file}! Please create it first." if Place.find(s.sub(/(.*)\{\D?(\d+)\D*\}(.*)/,'\2').to_i).nil? }
    (doc/'subjectreference').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the subject #{s} mentioned in #{file}! Please create it first." if Topic.find(s.sub(/(.*)\{\D?(\d+)\D*\}(.*)/,'\2').to_i).nil? }
    (doc/'userfield_1').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the organization #{s} mentioned in #{file}! Please create it first." if Organization.find_by_title(s).nil? }
    (doc/'userfield_2').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the project #{s} mentioned in #{file}! Please create it first." if Project.find_by_title(s).nil? }
    (doc/'userfield_3').collect(&:inner_text).uniq.reject(&:blank?).each{|s| raise "Could not find the sponsor #{s} mentioned in #{file}! Please create it first." if Sponsor.find_by_title(s).nil? }
    return true
  end
  
  def invalid_extension(filename, type)
    extension = FilenameUtils.extension_without_dot(filename).downcase
    return ['db', 'ini'].include?(extension) || type == 'images' && !Image::VALID_TYPES.keys.include?(extension)
  end
  
  def search_media_by_classification(classification, filename)
    joins_array = [:workflow]
    conditions_string = 'workflows.original_filename LIKE ?'
    conditions_array = ["#{basename(filename)}.%"]
    classification.each do |c|
      c_class= c.class
      if c_class != String
        case c_class.name
        when 'Place'
          joins_array << :locations
          conditions_string << ' AND locations.feature_id = ?'
          conditions_array << c.id
        when 'Topic'
          joins_array << :media_category_associations
          conditions_string << ' AND media_category_associations.category_id = ?'
          conditions_array << c.id
        end
      end
    end
    Medium.find(:first, :joins => joins_array, :conditions => [conditions_string] + conditions_array)
  end
  
  def media_pro_xml_hash(filename, path)
    medium_hash = { :type => 'metadata', :classifications => [], :file_name => filename, :path => path }
    medium_hash
  end
  
  
  def media_hash(type, classification, filename, path, check_existence)
    medium_hash = { :type => type, :classifications => classification, :file_name => filename, :path => path }
    if check_existence
      medium = search_media_by_classification(classification, filename)
      medium_hash[:id] = medium.id if !medium.nil?
    end
    medium_hash
  end
  
  def fork_media_importation(media, metadata, classification_types)
    #avoids race condition
    register_active_process
    spawn_block do
      begin
        start_log('Beginning importation.')
        write_to_log("Spawning main process #{Process.pid}.")
        parent = Process.pid
        done = true
        current = 0
        size = media.size
        imported_media = Hash.new
        while current<size
          interval = 1 # media[current][:type]=='typescripts' ? 1 : 10
          upper_limit = current+interval
          limit = upper_limit<=size ? upper_limit : size
          media_batch = media[current...limit]
          last_processed = nil
          sid = spawn_block do
            write_to_log("Spawning sub-process #{Process.pid}.")
            register_active_process
            last_processed = do_media_importation(media_batch, classification_types)
            Rails.cache.write("multimedia_importation/last_processed/#{Process.pid}", last_processed)
            register_active_process(parent)
          end
          wait([sid])
          last_processed = Rails.cache.read("multimedia_importation/last_processed/#{sid.handle}")
          Rails.cache.delete("multimedia_importation/last_processed/#{sid.handle}")
          imported_media.merge!(last_processed)
          current = limit
        end
        do_metadata_importation(metadata, imported_media)
      rescue Exception => exc
        finish_log("Import was abruptly terminated: #{exc.to_s}")
      else
        finish_log("Importation finished normally.")
      end
    end
  end
  
  def fork_media_update(media)
    #avoids race condition
    register_active_process
    background_process do
      begin
        start_log('Beginning media update.')
        write_to_log("Spawning main process #{Process.pid}.")
        parent = Process.pid
        done = true
        interval = 10
        current = 0
        size = media.size
        while current<size
          upper_limit = current+interval
          limit = upper_limit<=size ? upper_limit : size
          media_batch = media[current...limit]
          background_process(true, false) do
            write_to_log("Spawning sub-process #{Process.pid}.")
            register_active_process
            media_batch.each{|media_update| do_media_update(media_update[:file_name], media_update[:id])}
            register_active_process(parent)
          end
          Process.wait
          current = limit
        end
      rescue Exception => exc
        finish_log("Media update was abruptly terminated: #{exc.to_s}")
      else
        finish_log("Media update finished normally.")
      end
    end
  end
  
  def do_media_update(original, id)
    begin
      medium = Medium.find(id)
    rescue ActiveRecord::RecordNotFound
      write_to_log("File #{original} did not match any existing medium.")
    else
      cold_storage_file = medium.cold_storage
      if !cold_storage_file.nil? && File.exist?(original)
        begin
          cold_storage_folder = File.dirname(cold_storage_file)
          mkdir_p(cold_storage_folder)
          attachment = medium.attachment
          attachment_filename = attachment.filename
          previous_filename_extension = extension_without_dot(attachment_filename).downcase
          new_filename_extension = extension_without_dot(original)
          new_filename_downcase_extension = new_filename_extension.downcase
          if new_filename_downcase_extension == previous_filename_extension
            cp(original, cold_storage_file)
          else
            new_filename = File.join(cold_storage_folder, "#{medium.id}.#{new_filename_extension}")
            cp(original, new_filename)
            attachment.filename = File.basename(new_filename)
            attachment.content_type = Image::VALID_TYPES[new_filename_downcase_extension]
            rm_f(cold_storage_file)
          end
          size = File.size(original)
          if attachment.size != size
            attachment.size = size
            attachment.save
          end
        rescue Exception
          write_to_log("Could not copy Medium ID #{medium.id} to cold storage.")
        else
          write_to_log("Medium ID #{medium.id} orginal was successfully updated in cold storage.")
        end
        begin
          medium.update_thumbnails
        rescue Exception
          write_to_log("Regeneration of thumbnails for Medium ID #{medium.id} failed.")
        else
          write_to_log("Regeneration of thumbnails for Medium ID #{medium.id} was successful.")
        end
      end
    end
  end
  
  def log_suffix
    return 'import'
  end
    
  def do_media_importation(media, classification_types)
    objects = Hash.new
    previous_classification = Array.new(3)
    imported_media = Hash.new
    for medium_to_import in media
      classification_ids = medium_to_import[:classification]
      0.upto(2) do |i|
        classification_id = classification_ids[i].blank? ? nil : classification_id = classification_ids[i]
        if classification_id!=previous_classification[i]
          objects[classification_types[i]]= classification_id
          previous_classification[i] = classification_id
        end
      end
      begin
        medium = add_medium(medium_to_import[:file_name], medium_to_import[:type], objects['recording_note'])
        imported_media[File.basename(medium_to_import[:file_name])] = medium.id
        write_to_log("Imported #{medium_to_import[:file_name]} as medium #{medium.id}.")
      rescue Exception => exc
        write_to_log("Import of #{medium_to_import[:file_name]} failed: #{exc}")
      else
        roots = Hash.new
        objects.each do |model_name, object|
          next if object.nil?
          if model_name=='administrative_unit'
            Location.create :medium => medium, :administrative_unit_id => object
          elsif model_name != 'recording_note'
            roots[object] ||= Topic.find(object).root.id
            MediaCategoryAssociation.create :medium_id => medium.id, :category_id => object, :root_id => roots[object]
          end
        end
      end
    end
    return imported_media
  end
  
  def do_metadata_importation(metadata_files, imported_media)
    rep_type = ReproductionType.find(4)
    for metadata_file in metadata_files
      basename = File.basename(metadata_file[:file_name])
      metadata_source = MetadataSource.find_by_filename(basename)
      metadata_source = MetadataSource.create(:filename => basename) if metadata_source.nil?
      parse_metadata(metadata_file[:file_name]).each do |filename, attrs|
        medium_id = imported_media[filename]
        medium = medium_id.blank? ? nil : Medium.find(medium_id)
        if medium.nil?
          w = Workflow.find_by_original_filename(filename)
          medium = w.medium if !w.nil?
        end
        next if medium.nil?
        medium.workflow.update_attribute(:metadata_source_id, metadata_source.id)
        s = attrs['author']
        if !s.blank?
          r = AuthenticatedSystem::Person.find_by_fullname(attrs['author'])
          medium.photographer = r if !r.nil?
        end
        s = attrs['Private Note']
        medium.private_note = s if !s.blank?
        medium.save if medium.changed?
        s = attrs['copyright']
        if !s.blank?
          r = CopyrightHolder.find_by_title(s)
          Copyright.create(:medium_id => medium.id, :copyright_holder_id => r.id, :reproduction_type_id => rep_type.id) if !r.nil?
        end        
        s = attrs['category']
        if !s.blank?
          fid = s.sub(/(.*)\{\D?(\d+)\D*\}(.*)/,'\2').to_i
          lat = attrs['latitude']
          lat = lat.gsub(/(\w)\s+(\d+)\D+(\d+)\D+([\d\.]+)/){($1.upcase=='S' ? -1 : 1) * ($2.to_f + $3.to_f/60 + $4.to_f/3600)} if !lat.blank? && lat.to_f == 0
          lng = attrs['longitude']
          lng = lng.gsub(/(\w)\s+(\d+)\D+(\d+)\D+([\d\.]+)/){($1.upcase=='W' ? -1 : 1) * ($2.to_f + $3.to_f/60 + $4.to_f/3600)} if !lng.blank? && lng.to_f == 0
          Location.create(:medium_id => medium.id, :feature_id => fid, :lat => lat, :lng => lng, :spot_feature => attrs['Location Feature'], :notes => attrs['Location Notes'])
        end
        s = attrs['caption']
        if !s.blank?
          name = attrs['writer']
          if name.blank?
            creator_id = nil
          else
            creator = AuthenticatedSystem::Person.find_by_fullname(name)
            creator_id = creator.nil? ? nil : creator.id
          end
          s = "<p>#{s}</p>" if !s.starts_with?('<p>')
          r = Description.find_by_title(s)
          if r.nil?
            r = Description.create :title => s, :creator_id => creator_id
            medium.descriptions << r
          else
            r.update_attribute(:creator_id, creator_id) if !creator_id.nil?
            medium.descriptions << r if !medium.description_ids.include? r.id
          end
        end
        s = attrs['subjectreference']
        if !s.blank?
          topic_id = s.sub(/(.*)\{\D?(\d+)\D*\}(.*)/,'\2').to_i
          t = Topic.find(topic_id)
          if !t.nil?
            MediaCategoryAssociation.create(:category_id => topic_id, :medium_id => medium.id, :root_id => t.root.id)
          end
        end
        s = attrs['Affiliation Organization']
        if !s.blank?
          organization = Organization.find_by_title(s)
          if !organization.nil?
            project_title = attrs['Affiliation Project']
            if project_title.blank?
              project_id = nil
            else
              project =  Project.find_by_title(project_title)
              project_id = project.nil? ? nil : project.id
            end
            sponsor_title = attrs['Affiliation Sponsor']
            if sponsor_title.blank?
              sponsor_id = nil
            else
              sponsor = Sponsor.find_by_title(sponsor_title)
              sponsor_id = sponsor.nil? ? nil : sponsor.id
            end
            Affiliation.create :medium_id => medium.id, :organization_id => organization.id, :project_id => project_id, :sponsor_id => sponsor_id
          end          
        end
        s = attrs['Caption']
        if !s.blank?
          r = Caption.find_by_title(s)
          if r.nil?
            r = Caption.create :title => s
            medium.captions << r
          else
            medium.captions << r if !medium.caption_ids.include? r.id
          end
        end
      end
    end
  end
  
  private
  
  def parse_metadata(file)
    doc = open(file) { |f| Hpricot(f) }
    user_field_names = (doc/'catalogtype/userfieldlist/userfielddefinition').collect(&:inner_text)
    metadata = {}
    (doc/'catalogtype/mediaitemlist/mediaitem').each do |m|
      asset_props = (m/'assetproperties').first
      filename = (asset_props/'filename').first.inner_text
      attrs = {'uniqueid' => (asset_props/'uniqueid').first.inner_text.to_i}
      (m/'annotationfields').first.children.select(&:elem?).each{|e| attrs[e.name] = e.inner_text}
      (m/'userfields').first.children.select(&:elem?).each{|e| attrs[user_field_names[e.name.gsub(/[^\d]/,'').to_i-1]] = e.inner_text}
      metadata[filename] = attrs
    end
    return metadata
  end
  
  def add_image(image_filename, recording_note = nil)
    ext = extension_without_dot(image_filename).downcase
    content_type = Image::VALID_TYPES[ext]
    if content_type.nil?
      raise 'File type not supported!'
    end
    expanded_path = File.expand_path(image_filename)
    image = Image.create :temp_path => expanded_path, :filename => image_filename, :content_type => content_type
    if image.nil?
      raise "Error processing image!" 
    else
      Picture.create :image => image, :recording_note => recording_note
    end
  end
  
  def add_movie(movie_filename, recording_note = nil)
    ext = extension_without_dot(movie_filename).downcase
    
    content_type = Movie::VALID_TYPES[ext]
    if content_type.nil?
      raise 'File type not supported!'
    end
    movie = Movie.create :temp_path => File.expand_path(movie_filename), :filename => movie_filename, :content_type => content_type
    if movie.id.nil?
      raise "Error processing movie!" 
    end
    medium = Video.create :movie => movie, :recording_note => recording_note
    medium.process(false)
    return medium    
  end
  
  def add_typescript(typescript_filename, recording_note = nil)
    pos = typescript_filename.rindex('.')
    if pos>0
      ext = typescript_filename[pos+1...typescript_filename.size]
      orig_name = typescript_filename[0...pos]              
    else
      ext = ''
      orig_name = typescript_filename
    end
    content_type = Typescript::VALID_TYPES[ext]
    if content_type.nil?
      raise 'File type not supported!'
    end
    typescript = Typescript.create :temp_path => File.expand_path(typescript_filename), :filename => typescript_filename, :content_type => content_type
    if typescript.id.nil?
      raise 'Something went wrong processing document!'
    end
    medium = Document.create :typescript => typescript, :recording_note => recording_note
    medium.create_thumbnails if medium.create_or_update_preview
    return medium
  end
  
  def add_medium(medium_filename, type, recording_note = nil)
    case type
    when 'images'
      add_image(medium_filename, recording_note)
    when 'movies'
      add_movie(medium_filename, recording_note)
    when 'typescripts'
      add_typescript(medium_filename, recording_note)
    end
  end
end