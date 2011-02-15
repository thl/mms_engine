# ImportMedia
require 'config/environment'

module MultimediaImportation
  include ForkedNotifier
  include FilenameUtils
  
  def assess_media_importation(source, type, check_existence, *classifications)
    levels = Hash.new
    objects = Hash.new
    media = Array.new
    models = {'place' => Place, 'topic' => Topic }
    Dir.chdir(source) do
      Dir.glob('*').sort.each do |classification_title_0|
        next if !File.directory?(classification_title_0)
        #  raise "File <i>#{classification_title_0}</i> was found directly under #{source}. <i>Relative folder containing media to import</i> should include sub-folders which you specified (in classification scheme setting) to represent <i>#{classifications[0].pluralize}</i> with the media placed under them!"
        #end
        if classifications[0].blank?
          raise "First level folder found but no first level classification defined!"
        end
        objects[classifications[0]] = classifications[0]=='recording_note' ? classification_title_0 : objects[classifications[0]] = models[classifications[0]].find_by_title(classification_title_0)
        if objects[classifications[0]].nil?
          raise "Could not find the <i>#{classifications[0]}</i> called <i>#{classification_title_0}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
        end
        levels[0] = classifications[0]
        Dir.chdir(classification_title_0) do
          Dir.glob('*').sort.each do |classification_title_1|
            next if classification_title_1.downcase =~ /\.db$|\.ini$/
            if File.directory?(classification_title_1)
              if classifications[1].blank?
                raise "Second level folder <i>#{classification_title_1}</i> found but no second level classification defined!"
              end
              objects[classifications[1]] = classifications[1]=='recording_note' ? classification_title_1 : models[classifications[1]].find_by_title(classification_title_1)
              if objects[classifications[1]].nil?
                raise "Could not find the <i>#{classifications[1]}</i> called <i>#{classification_title_1}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
              end
              levels[1] = classifications[1]
              Dir.chdir(classification_title_1) do
                Dir.glob('*').sort.each do |classification_title_2|
                  next if classification_title_2.downcase =~ /\.db$|\.ini$/         
                  if File.directory?(classification_title_2)
                    if classifications[2].blank?
                      raise "Third level folder <i>#{classification_title_2}</i> found but no third level classification defined!"
                    end
                    objects[classifications[2]] = classifications[2]=='recording_note' ? classification_title_2 : models[classifications[2]].find_by_title(classification_title_2)
                    if objects[classifications[2]].nil?
                      raise "Could not find the <i>#{classifications[2]}</i> called <i>#{classification_title_2}</i>. If this is what you meant, please create it first. If not, please recheck the settings under <i>classification scheme</i>."
                    end                    
                    levels[2] = classifications[2]
                    Dir.chdir(classification_title_2) do
                      Dir.glob('*').sort.each do |classification_title_3|
                        if File.directory?(classification_title_3)
                          raise "Found fourth level folder <i>#{classification_title_3}</i> found but importation does not support fourth level classifications!"
                        end
                        next if classification_title_3.downcase =~ /\.db$|\.ini$/
                        classification = classifications.collect { |c| objects[c]  }
                        media << media_hash(type, classification, classification_title_3, File.join(source, classification_title_0, classification_title_1, classification_title_2, classification_title_3), check_existence)
                      end
                    end
                    objects[levels[2]] = nil
                  else
                    classification = classifications[0..1].collect { |c| objects[c]  }
                    media << media_hash(type, classification, classification_title_2, File.join(source, classification_title_0, classification_title_1, classification_title_2), check_existence)
                  end
                end
              end
              objects[levels[1]] = nil
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
  
  def media_hash(type, classification, filename, path, check_existence)
    medium_hash = { :type => type, :classifications => classification, :file_name => filename, :path => path }
    if check_existence
      medium = search_media_by_classification(classification, filename)
      medium_hash[:id] = medium.id if !medium.nil?
    end
    medium_hash
  end
  
  def fork_media_importation(media, classification_types)
    #avoids race condition
    register_active_process
    background_process do
      begin
        start_log('Beginning importation.')
        write_to_log("Spawning main process #{Process.pid}.")
        parent = Process.pid
        done = true
        current = 0
        size = media.size
        while current<size
          interval = 1 # media[current][:type]=='typescripts' ? 1 : 10
          upper_limit = current+interval
          limit = upper_limit<=size ? upper_limit : size
          media_batch = media[current...limit]
          background_process(true, false) do
            write_to_log("Spawning sub-process #{Process.pid}.")
            register_active_process
            do_media_importation(media_batch, classification_types)
            register_active_process(parent)
          end
          Process.wait
          current = limit
        end
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
            MediaCategoryAssociation.create :medium => medium, :category_id => object, :root_id => roots[object]
          end
        end
      end
    end
  end
  
  private
  
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