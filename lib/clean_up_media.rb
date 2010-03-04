# CleanUpMedia
require 'config/environment'

module CleanUpMedia
  def self.clean_up_media
    # start with deleting extra-images
    clean_up_folder('public/images', ['_normal.', '_thumb.'])
    clean_up_folder('public/movies', ['_thumb', '_high', '_low', '_preview'])
  end
  
  def self.clean_up_folder (folder, acceptable_names)
    Dir.chdir(folder) do
      Dir.glob('*').sort.each do |folder_name|
        next if !File.directory?(folder_name)
        next if folder_name =~ /.+\D.+/
        Dir.chdir(folder_name) do
          Dir.glob('*').sort.each do |file_name|
            deleteable = true
            file_name.downcase!
            for acceptable_name in acceptable_names
              if file_name.index(acceptable_name)
                deleteable = false
                break
              end
            end
            File.delete(file_name) if deleteable
            #puts "Deleting #{file_name}" if deleteable
          end
        end
      end
    end
  end
  
  def self.wipe_dictionaries
    Word.connection.execute("TRUNCATE TABLE `words`")
    GrammaticalClass.connection.execute("TRUNCATE TABLE `grammatical_classes`")
    Definition.connection.execute("TRUNCATE TABLE `definitions`")
    Letter.connection.execute("TRUNCATE TABLE `letters`")
    Letter.connection.execute("TRUNCATE TABLE `loan_types`")
    Letter.connection.execute("TRUNCATE TABLE `dialects`")
    Letter.connection.execute("TRUNCATE TABLE `glossaries`")
    Letter.connection.execute("TRUNCATE TABLE `definitions_keywords`")
  end
end