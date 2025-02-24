# require 'config/environment'
namespace :mms do
  namespace :helpers do
    desc 'Converts strings to symbols in SOURCE to help with the conversion of translated messages.'
    task :str_to_sym do
      source = ENV['SOURCE']
      if source.nil?
        puts 'SOURCE argument required.'
      else
        File.foreach(source) do |line|
          next if line.nil?
          line.strip!
          next if line.blank?
          puts line.strip.parameterize.to_s.underscore
        end
      end
    end
    
    desc 'Populate iiif_image table. Optionally from PICTURE_ID onwards'
    task populate_iiif_data: :environment do |t|
      require_relative '../process_iiif.rb'
      picture_id = ENV['PICTURE_ID']
      ProcessIiif.populate(picture_id)
    end
    
    desc 'Delete images stored for pictures that have an iiif association. Optionally from PICTURE_ID onwards.'
    task remove_images_with_iiif_data: :environment do |t|
      require_relative '../process_iiif.rb'
      picture_id = ENV['PICTURE_ID']
      ProcessIiif.remove(picture_id)
    end
  end  
end