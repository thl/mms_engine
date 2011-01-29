# Currently it is hard-coded into pictures. Later should extend for videos, etc.
module MediaProcessor
  module ControllerExtension
    include ForkedNotifier

    def log_suffix
      return 'processing'
    end

    def update_all_thumbnails(id_start = nil, id_end = nil, media_type=Picture)
      #avoids race condition
      register_active_process
      background_process do
        begin
          start_log('Beginning thumb regeneration.')
          write_to_log("Spawning main process #{Process.pid}.")
          parent = Process.pid
          done = true
          interval = 10
          current = 0
          media = media_type.range(id_start, id_end)
          size = media.size
          while current<size
            upper_limit = current+interval
            limit = upper_limit<=size ? upper_limit : size
            media_batch = media[current...limit]
            background_process(true, false) do
              write_to_log("Spawning sub-process #{Process.pid}.")
              register_active_process
              media_batch.each do |medium|
                medium.update_thumbnails
                write_to_log("Medium #{medium.id} regenerated.")
              end
              register_active_process(parent)
            end
            Process.wait
            current = limit
          end
        rescue Exception => exc
          finish_log("Thumb regeneration was abruptly terminated: #{exc.to_s}")
        else
          finish_log("Thumb regeneration finished normally.")
        end
      end
    end
    
    def rename_all(id_start = nil, id_end = nil, media_type = Medium)
      #avoids race condition
      register_active_process
      background_process do
        begin
          start_log('Beginning renaming.')
          write_to_log("Spawning main process #{Process.pid}.")
          parent = Process.pid
          done = true
          interval = 100
          current = 0
          media = media_type.range(id_start, id_end)
          size = media.size
          while current<size
            upper_limit = current+interval
            limit = upper_limit<=size ? upper_limit : size
            media_batch = media[current...limit]
            background_process(true, false) do
              write_to_log("Spawning sub-process #{Process.pid}.")
              register_active_process
              media_batch.each do |medium|
                medium.rename
                write_to_log("Medium #{medium.id} renamed.")
              end
              register_active_process(parent)
            end
            Process.wait
            current = limit
          end
        rescue Exception => exc
          finish_log("Renaming was abruptly terminated: #{exc.to_s}")
        else
          finish_log("Renaming finished normally.")
        end
      end
    end
    
    def update_all_sizes(id_start = nil, id_end = nil, media_type = Medium)
      #avoids race condition
      register_active_process
      background_process do
        begin
          register_active_process
          start_log('Beginning updating all sizes.')
          write_to_log("Spawning main process #{Process.pid}.")
          media = media_type.range(id_start, id_end)
          media.each do |medium|
            if medium.update_sizes
              write_to_log("Updated medium #{medium.id}.")
            else
              write_to_log("Medium #{medium.id} is up to date.")              
            end
          end
        rescue Exception => exc
          finish_log("Updating sizes terminated: #{exc.to_s}")
        else
          finish_log("Updating sizes finished normally.")
        end
      end
    end
    
    def update_from_image_properties(id_start = nil, id_end = nil)
      #avoids race condition
      register_active_process
      background_process do
        begin
          start_log('Beginning updating metadata from exif tags.')
          write_to_log("Spawning main process #{Process.pid}.")
          parent = Process.pid
          done = true
          interval = 10
          current = 0
          media = Picture.range(id_start, id_end)
          size = media.size
          while current<size
            upper_limit = current+interval
            limit = upper_limit<=size ? upper_limit : size
            media_batch = media[current...limit]
            background_process(true, false) do
              write_to_log("Spawning sub-process #{Process.pid}.")
              register_active_process
              media_batch.each do |medium|
                updated = !medium.taken_on.nil? && !medium.capture_device_model.nil?
                if updated
                  write_to_log("Ignoring picture #{medium.id}.")                  
                else
                  updated = medium.update_from_image_properties
                  if updated
                    write_to_log("Picture #{medium.id} was updated.")
                  else
                    write_to_log("No exif information for picture #{medium.id}.")
                  end
                end
              end
              register_active_process(parent)
            end
            Process.wait
            current = limit
          end
        rescue Exception => exc
          finish_log("Updating metadata from exif tags terminated: #{exc.to_s}")
        else
          finish_log("Updating metadata from exif tags finished normally.")
        end
      end
    end
    
    def move_to_partitioned_paths(path)
      Dir.chdir(File.expand_path(File.join(RAILS_ROOT, 'public', path))) do
        Dir.glob('*').sort.each do |folder_name|
          next if !File.directory?(folder_name) || folder_name[0]==48 || (folder_name !~ /\A\d+\z/)
          dest_folders = ('%08d' % folder_name.to_i).scan(/..../)
          partition = dest_folders[0]
          mkdir(partition) unless File.exist?(partition)
          mv(folder_name, File.join(dest_folders))
          write_to_log("Partitioned #{folder_name}.")
        end
      end
    end
    
    def partition_cold_storage(path)
      cold_storage_setting = ApplicationSetting.find_by_title('cold_storage_folder')
      return if cold_storage_setting.nil?
      cold_storage_folder = cold_storage_setting.string_value
      return if cold_storage_folder.blank? || !File.exist?(cold_storage_folder)
      full_cold_storage_path = File.expand_path(File.join(cold_storage_folder, path))
      return if !File.exist?(full_cold_storage_path)
      Dir.chdir(full_cold_storage_path) do
        Dir.glob('*').sort.each do |file_name|
          next if File.directory?(file_name)
          pos = file_name.rindex('.')
          if pos.nil?
            file_id = file_name.to_i
            ext = ''
          else
            file_id = file_name[0...pos].to_i
            ext = file_name[pos...file_name.size]
          end
          dest_folders = ('%08d' % file_id).scan(/..../)
          dest_file = "#{File.join(dest_folders)}#{ext}"
          begin
            mkdir(dest_folders[0]) if !File.exist?(dest_folders[0])
            mv(file_name, dest_file)
          rescue
            write_to_log("Could not move #{file_name}!")
          else
            write_to_log("Moved #{file_name}.")
          end
        end
      end
    end
    
    def move_all_to_partitioned_paths(storages)
      #avoids race condition
      register_active_process
      background_process do
        begin
          register_active_process
          start_log('Beginning partitioning paths.')
          write_to_log("Spawning main process #{Process.pid}.")
          storages.each{ |storage| move_to_partitioned_paths(storage) }
        rescue Exception => exc
          finish_log("Partitioning paths terminated: #{exc.to_s}")
        else
          finish_log("Partitioning paths finished normally.")
        end
      end
    end
    
    def partition_all_cold_storage(storages)
      #avoids race condition
      register_active_process
      background_process do
        begin
          register_active_process
          start_log('Beginning partitioning cold storage.')
          write_to_log("Spawning main process #{Process.pid}.")
          storages.each{ |storage| partition_cold_storage(storage) }
        rescue Exception => exc
          finish_log("Partitioning cold storage terminated: #{exc.to_s}")
        else
          finish_log("Partitioning cold storage finished normally.")
        end
      end
    end
  end
    
  module PictureExtension
    def update_thumbnails
      original = fetch_original
      if !original.nil?
        image.temp_path=original
        # image.filename = id_name # now thumbnails have their names as ids.
        image.update_thumbnails
      end
    end

    def update_from_image_properties
      return false if !self.taken_on.nil? && !self.capture_device_model.nil?
      original = self.cold_storage_if_exists
      return false if original.nil?
      image.temp_path=original
      updated = false
      if self.taken_on.nil?
        date_time = image.date_time_original
        if !date_time.nil?
          self.taken_on = date_time
          updated = true
        end
      end
      if self.capture_device_model.nil?
        model_str = image.model
        if !model_str.blank?
          model = CaptureDeviceModel.find_by_exif_tag(model_str)
          if model.nil?
            maker_str = image.make
            if !maker_str.blank?
              maker = CaptureDeviceMaker.find_by_exif_tag(maker_str)
              maker = CaptureDeviceMaker.create(:title => maker_str.titleize, :exif_tag => maker_str) if maker.nil?
              model = maker.capture_device_models.create(:title => model_str, :exif_tag => model_str) 
              self.capture_device_model = model
              updated = true
            end
          else  
            self.capture_device_model = model
            updated = true            
          end
        end
      end
      updated = self.save if updated
      return updated
    end
    
    def update_taken_on(year)
      if self.taken_on.nil?
        self.update_attribute(:partial_taken_on, year) if self.partial_taken_on.blank? || !self.partial_taken_on.include?(year)
      elsif self.taken_on.year != year.to_i
        self.update_attributes(:taken_on => nil, :partial_taken_on => year)
      end
    end

    private

      def fetch_original
        # first check if original is there
        return image.full_filename if File.exist?(image.full_filename)

        # Check from cold-storage
        candidate = self.cold_storage_if_exists
        return candidate if !candidate.nil?

        # Regenerate thumbnails from highest resolution thumb available (huge, large, normal, essay)
        candidate = get_thumbnail_if_exists('huge')
        return candidate if !candidate.nil?
        candidate = get_thumbnail_if_exists('large')
        return candidate if !candidate.nil?
        candidate = get_thumbnail_if_exists('normal')
        return candidate if !candidate.nil?
        candidate = get_thumbnail_if_exists('essay')
        return candidate
      end

      def get_thumbnail_if_exists(thumbname)
        thumb = image.children.find(:first, :conditions => {:thumbnail => thumbname})
        if !thumb.nil?
          candidate = thumb.full_filename
          return candidate if File.exist?(candidate)
        end
        return nil
      end      
  end
  
  module MediumExtension
    def rename
      actual_media = self.attachment_id
      return if actual_media.nil?
      message = String.new
      save_to_cold_storage = true
      media_folder = self.class.public_folder
      save_to_cold_storage = false if self.class==Document
      parent = attachment
      folder = File.expand_path(File.join(RAILS_ROOT, 'public', media_folder, *parent.partitioned_path))
      begin
        filename = parent.filename
        original = File.join(folder, filename)
        # new_file_name = id_name
        wf = self.workflow
        if !File.exist?(original) && !wf.nil?
          filename = wf.original_filename
          original = File.join(folder, filename)
        end
        if File.exist?(original)
          if save_to_cold_storage
            cold_storage_file = self.cold_storage
            if !cold_storage_file.nil? && File.exist?(original)
              mkdir_p(File.dirname(cold_storage_file))
              cp(original, cold_storage_file)
              rm_f(original)
            end
          else
            new_file_name = id_name
            mv(original, File.join(folder, new_file_name)) if filename != new_file_name
          end
        end
        if wf.nil?
          Workflow.create :medium => self, :original_filename => parent.filename
          parent.filename = id_name
          parent.save
        end
      rescue Exception => exc
        message << "#{exc.to_s}<br/>"
      end
      parent.children.each do |thumb|
        filename = thumb.filename
        next if filename.blank?
        original = File.join(folder, filename)
        if !File.exist?(original) && !wf.nil?
          filename = "#{File.basename(wf.original_filename, '.*')}_#{thumb.thumbnail}#{extension(filename)}"
          original = File.join(folder, filename)
        end
        new_file_name = "#{id}_#{thumb.thumbnail}#{extension(filename)}"
        begin
          mv(original, File.join(folder, new_file_name)) if filename != new_file_name && File.exist?(original)
          if thumb.filename != new_file_name
            thumb.filename = new_file_name
            thumb.save
          end
        rescue Exception => exc
          message << "#{exc.to_s}<br/>"
        end        
      end
      return message
    end
    
    def update_sizes
      updated = false
      path = self.cold_storage_if_exists
      original_attachment = self.attachment
      if !path.nil?
        size = File.size(path)
        if size!=original_attachment.size
          original_attachment.size = size
          original_attachment.save
          updated = true
        else
          updated = false
        end
      end      
      original_attachment.children.each do |attachment|
        path = attachment.full_filename
        if File.exists? path
          size = File.size(path)
          if size!=attachment.size
            attachment.size = size
            attachment.save
            updated = true
          end
        end              
      end
      return updated
    end      
  end
end