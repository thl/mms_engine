# require 'config/environment'
namespace :mms do
  namespace :media do
    media_extractor_description = "Extracts date and model from selected media in DB.\n" +
    "Takes a CSV where first row are the column names. Uses the column called workflows.original_filename\n" +
    "to search the entries and produces a tab delimited output with original filename, camera model, and\n" +
    "date the picture was taken.\n" +
    "Syntax:\n" +
    "rake mms:media:extract FILENAME=file.csv"

    metadata_description = "Task used to import metadata for THL images.\n" +
    "Takes a CSV where first row are the column names. The following column names are accepted and interpreted:\n" +
    "workflows.original_filename, workflows.original_medium_id, workflows.other_id, workflows.sequence_order,\n" +
    "workflows.notes, media.recording_note, media.private_note, media.taken_on, media.photographer,\n" +
    "recording_orientations.title, captions.title, collections.title, administrative_units.title,\n" +
    "locations.notes, locations.spot_feature, descriptions.title,\n" +
    "descriptions.creator, keywords.title, sources.title, and media_source_associations.shot_number."
        
    desc 'Deletes all original pictures and videos from the public folder.'
    task :cleanup do |t|
      require_relative '../lib/clean_up_media.rb'
      CleanUpMedia.clean_up_media
    end
    
    desc 'Auxiliary method used to associate copyright, copyright holder, and collection to Bhutanese material.'
    task :tag do |t|
      require_relative '../lib/tag_media.rb'
      TagMedia.tag_current_media
    end
    
    desc media_extractor_description
    task :extract do |t|
      require_relative '../lib/media_extractor.rb'
      filename = ENV['FILENAME']
      if filename.blank?
        puts media_extractor_description
      else
        MediaExtractor.extract_metadata(filename)
      end
    end
  end
  
  namespace :dictionaries do
    desc 'Empties all dictionary tables. Use only if you want to re-import.'
    task :wipe do |t|
      require_relative '../lib/clean_up_media.rb'
      CleanUpMedia.wipe_dictionaries
    end

    desc 'rake import:sort_dictionary LANGUAGES=lg1,lg2,...'
    task :sort do |t|
      require_relative '../lib/dictionary_importation.rb'
      DictionaryImportation.sort_words(ENV['LANGUAGES'].split(','))
    end
  end
  
  namespace :documents do
    desc 'Task to convert captions to titles for documents.'
    task :caption_to_title do |t|
      require_relative '../lib/document_processing.rb'
      DocumentProcessing.caption_to_title      
    end
  end
  
  namespace :pictures do
    match_date_with_topic_description = "Task used to match date taken with topic's names that include year.\n" +
    "Takes a topic id list separated by commas. This method loops through all media associated with" +
    "each topic and matches the year with it." +
    "Syntax:\n" +
    "rake mms:pictures:match_date_with_topic TOPIC_IDS=1,2,3"
    desc match_date_with_topic_description
    task :match_date_with_topic do |t|
      require_relative '../lib/tag_media.rb'
      topic_ids = ENV['TOPIC_IDS']
      if topic_ids.blank?
        puts match_date_with_topic_description
      else
        TagMedia.match_date_with_topics(topic_ids)
      end
    end
  end
end