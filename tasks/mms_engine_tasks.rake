require 'config/environment'
namespace :mms do
  desc "Syncronize extra files for MMS"
  task :sync do
    system "rsync -ruv --exclude '.*' vendor/plugins/mms_engine/db/migrate db"
    system "rsync -ruvK --exclude '.*' vendor/plugins/mms_engine/public ."
  end
  
  desc "Deploys collections to knowledge maps (authenticating through TMB_USER arguments) making the appropriate replacements."
  task :deploy_categories do |t|
    require File.join(File.dirname(__FILE__), "../lib/knowledge_maps_deployer.rb")
    TopicalMapResource.user = ENV['TMB_USER']
    if !TopicalMapResource.user.blank?
      puts "Password for #{TopicalMapResource.user}:"
      TopicalMapResource.password = STDIN.gets.chomp
      KnowledgeMapsDeployer.do_deployment
    else
      puts 'User and password needed! Use TMB_USER= to set user from command-line.'
    end
  end
  
  namespace :string_helpers do
    desc 'Converts strings to symbols in SOURCE to help with the conversion of translated messages.'
    task :to_symbol do
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
  end
  
  namespace :import do
    media_import_description = "Batch process to import media.\n" + 
    "Syntax:\n" +
    "rake import:images SOURCE=path-to-folder [CLASSIFICATION=classification-type [CLASSIFICATION2=classification-type2 [CLASSIFICATION3=classification-type3]]]\n" +
    "rake import:movies SOURCE=path-to-folder [CLASSIFICATION=classification-type [CLASSIFICATION2=classification-type2]]\n" +
    "rake import:typescripts SOURCE=path-to-folder [CLASSIFICATION=classification-type]\n" +
    "\nValid values for classification-type are administrative_unit and subject.\n" +
    "Valid values for classification-type2 is subject.\n" +
    "Valid values for classification-type3 is recording note.\n" +
    "\nIf more than one is specified, the first folder is assumed to be the first, the second level of folders the second, and so forth."

    dictionary_import_description = "\nFor importing dictionaries.\n" +
    "Syntax:\n" +
    "\nrake import:dictionary FILE_NAME=file-name-of-tab-dict WORD_LANGUAGE=language-code DEFINITION_LANGUAGE=language-code LETTER_MODE=[calculate] COLS=col-name1,col-name2,... GLOSSARY_NAME=glossary-name\n" +
    "rake import:dictionaries FILE_NAME=file-name-of-tab-dict WORD_LANGUAGE=language-code DEFINITION_LANGUAGE=language-code PATH_TO_DICTS=path-to-files COLS=col-name1,col-name2,... GLOSSARY_NAME=glossary-name\n" +
    "\nExpected column names: word, definition, grammatical_class, letter, loan_type, dialect and keywords (notice the plural)."

    media_extractor_description = "Extracts date and model from selected media in DB.\n" +
    "Takes a CSV where first row are the column names. Uses the column called workflows.original_filename\n" +
    "to search the entries and produces a tab delimited output with original filename, camera model, and\n" +
    "date the picture was taken.\n" +
    "Syntax:\n" +
    "rake import:media_extractor FILENAME=file.csv"

    metadata_description = "Task used to import metadata for THL images.\n" +
    "Takes a CSV where first row are the column names. The following column names are accepted and interpreted:\n" +
    "workflows.original_filename, workflows.original_medium_id, workflows.other_id, workflows.sequence_order,\n" +
    "workflows.notes, media.recording_note, media.private_note, media.taken_on, media.photographer,\n" +
    "recording_orientations.title, captions.title, collections.title, administrative_units.title,\n" +
    "media_administrative_locations.notes, media_administrative_locations.spot_feature, descriptions.title,\n" +
    "descriptions.creator, keywords.title, sources.title, and media_source_associations.shot_number."

    desc media_import_description
    task :images do |t|
      require File.join(File.dirname(__FILE__), "../lib/multimedia_importation.rb")
      source = ENV['SOURCE']
      ENV['CLASSIFICATION'] ||= 'administrative_unit'
      if source.blank?
        puts media_import_description
      else
        puts MultimediaImportation.do_media_importation(source, 'images', ENV['CLASSIFICATION'], ENV['CLASSIFICATION2'], ENV['CLASSIFICATION3'])
      end
    end

    desc media_import_description
    task :movies do |t|
      require File.join(File.dirname(__FILE__), "../lib/multimedia_importation.rb")
      source = ENV['SOURCE']
      ENV['CLASSIFICATION'] ||= 'administrative_unit'
      if source.blank?
        puts media_import_description
      else
        puts MultimediaImportation.do_media_importation(source, 'movies', ENV['CLASSIFICATION'], ENV['CLASSIFICATION2'], ENV['CLASSIFICATION3'])
      end
    end 

    desc media_import_description
    task :typescripts do |t|
      require File.join(File.dirname(__FILE__), "../lib/multimedia_importation.rb")
      source = ENV['SOURCE']
      ENV['CLASSIFICATION'] ||= 'administrative_unit'
      if source.blank?
        puts media_import_description
      else
        puts MultimediaImportation.do_media_importation(source, 'typescripts', ENV['CLASSIFICATION'], ENV['CLASSIFICATION2'], ENV['CLASSIFICATION3'])
      end
    end

    # To import Jero dictionary run:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/jero_english.csv WORD_LANGUAGE=jee DEFINITION_LANGUAGE=eng LETTER_MODE=calculate COLS=word,loan_type,dialect,grammatical_class,definition "GLOSSARY_NAME=Opgenort's Kiranti Language Dictionaries"
    #
    # To import Wambule dictionary run:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/wambule_english.csv WORD_LANGUAGE=wme DEFINITION_LANGUAGE=eng LETTER_MODE=calculate COLS=definition,word,loan_type,dialect,grammatical_class "GLOSSARY_NAME=Opgenort's Kiranti Language Dictionaries"
    #
    # To import Thangmi dictionary run:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/nepali_thangmi_english.csv WORD_LANGUAGE=thf DEFINITION_LANGUAGE=nep LETTER_MODE=calculate COLS=id,definition,word,english "GLOSSARY_NAME=Mark Turin's Thangmi - Nepali - English Dictionary"
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/nepali_thangmi_english.csv WORD_LANGUAGE=nep DEFINITION_LANGUAGE=eng LETTER_MODE=calculate COLS=id,word,thangmi,definition "GLOSSARY_NAME=Mark Turin's Thangmi - Nepali - English Dictionary"
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/nepali_thangmi_english.csv WORD_LANGUAGE=thf DEFINITION_LANGUAGE=eng LETTER_MODE=calculate COLS=id,nepali,word,definition "GLOSSARY_NAME=Mark Turin's Thangmi - Nepali - English Dictionary"
    #
    # To import Nepali dictionary run:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/english_nepali.csv WORD_LANGUAGE=eng DEFINITION_LANGUAGE=nep LETTER_MODE=calculate COLS=id,word,grammatical_class,definition,lesson,keywords "GLOSSARY_NAME=Cornell's Nepali-English & English-Nepali Glossary"
    # rake import:dictionary FILE_NAME=db/migrate/dicts/nepali/nepali_english.csv WORD_LANGUAGE=nep DEFINITION_LANGUAGE=eng LETTER_MODE=calculate COLS=id,word,grammatical_class,definition,lesson,keywords "GLOSSARY_NAME=Cornell's Nepali-English & English-Nepali Glossary"
    #
    # To import Ives Waldo's dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/ives-waldo.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=Ives Waldo's Dictionary"
    # To import Rangjung Yeshe's dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/rangjung-yeshe.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=The Rangjung Yeshe Tibetan-English Dictionary of Buddhist Culture version 3.0"  
    # To import Richard Barron's dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/richard-barron.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=Richard Barron's Tibetan-English Word List"
    # To import Jim Valby's dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/jim-valby.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=Jim Valby's Dictionary"  
    # To import Yogacara glossary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/yogacara-glossary.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=san COLS=letter,word,definition "GLOSSARY_NAME=A Tibetan-Sanskrit Table of Buddhist Terminology based on the Yogacarabhumi"
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/yogacara-glossary.txt WORD_LANGUAGE=san DEFINITION_LANGUAGE=bod LETTER_MODE=calculate COLS=other,definition,word "GLOSSARY_NAME=A Tibetan-Sanskrit Table of Buddhist Terminology based on the Yogacarabhumi"
    # To import Dan Martin's dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/dan-martin.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=Tibetan Vocabulary by Dan Martin"
    # To import Jeffrey Hopkins' dictionary:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/jeffrey-hopkins-one-field.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=eng COLS=letter,word,definition "GLOSSARY_NAME=Jeffrey Hopkins' Tibetan-Sanskrit-English Dictionary version 2.0.0"
    # To import bod rgya tshig mdzod chen mo:
    # rake import:dictionary FILE_NAME=db/migrate/dicts/tibetan/tshig-mdzod.txt WORD_LANGUAGE=bod DEFINITION_LANGUAGE=bod COLS=letter,word,definition "GLOSSARY_NAME=bod rgya tshig mdzod chen mo"  
    desc media_import_description
    task :dictionary do |t|
      require File.join(File.dirname(__FILE__), "../lib/dictionary_importation.rb")
      cols_string = ENV['COLS']
      cols = Hash.new
      order_options = Hash.new
      order_options[:letter_order] = -1 if ENV['LETTER_MODE']=='calculate'
      cols_string.split(',').each_with_index { |col_name, col_num| cols[col_name.to_sym] = col_num } if !cols_string.blank?
      DictionaryImportation.add_dictionary(ENV['FILE_NAME'], ENV['WORD_LANGUAGE'], ENV['DEFINITION_LANGUAGE'], order_options, cols, ENV['GLOSSARY_NAME'])
    end

    # To import dzongkha to dzongkha run:
    # rake import:dictionaries FILE_NAMES=KA,KHA,GA,NGA,CHA,CHHA,JA,NYA,TA,THA,DA,NA,PA,PHA,BA,MA,TSA,TSHA,DZA,WA,ZHA,ZA,AA,YA,RA,LA,SHA,SA,HA,AH WORD_LANGUAGE=dzo DEFINITION_LANGUAGE=dzo PATH_TO_DICTS=db/migrate/dicts/dzo-dzo "GLOSSARY_NAME=Dzongkha to Dzongkha Dictionary"
    #
    # To import dzongkha to english run:
    # rake import:dictionaries FILE_NAMES=Ka,Kha,Ga,Nga,Cha,Chha,Ja,Nya,Ta,Tha,Da,Na,Pa,Pha,Ba,Ma,Tsa,Tsha,Dza,Wa,Zha,Za,Aa,Ya,Ra,La,Sha,Sa,Ha,Ah WORD_LANGUAGE=dzo DEFINITION_LANGUAGE=eng PATH_TO_DICTS=db/migrate/dicts/dzo-eng "GLOSSARY_NAME=Dzongkha to English Dictionary"
    #
    # To import english to dzongkha run:
    # rake import:dictionaries FILE_NAMES=A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z WORD_LANGUAGE=eng DEFINITION_LANGUAGE=dzo PATH_TO_DICTS=db/migrate/dicts/eng-dzo COLS=word,grammatical_class,definition "GLOSSARY_NAME=English to Dzongkha Dictionary"
    desc media_import_description
    task :dictionaries do |t|
      require File.join(File.dirname(__FILE__), "../lib/dictionary_importation.rb")
      cols_string = ENV['COLS']
      cols = Hash.new
      cols_string.split(',').each_with_index { |col_name, col_num| cols[col_name.to_sym] = col_num } if !cols_string.blank?
      DictionaryImportation.add_dictionaries(ENV['FILE_NAMES'].split(','), ENV['WORD_LANGUAGE'], ENV['DEFINITION_LANGUAGE'], ENV['PATH_TO_DICTS'], cols, ENV['GLOSSARY_NAME'])
    end

    desc 'Deletes all original pictures and videos from the public folder.'
    task :media_cleanup do |t|
      require File.join(File.dirname(__FILE__), "../lib/clean_up_media.rb")
      CleanUpMedia.clean_up_media
    end

    desc 'Empties all dictionary tables. Use only if you want to re-import.'
    task :wipe_dictionaries do |t|
      require File.join(File.dirname(__FILE__), "../lib/clean_up_media.rb")
      CleanUpMedia.wipe_dictionaries
    end

    desc 'rake import:sort_dictionary LANGUAGES=lg1,lg2,...'
    task :sort_dictionary do |t|
      require File.join(File.dirname(__FILE__), "../lib/dictionary_importation.rb")
      DictionaryImportation.sort_words(ENV['LANGUAGES'].split(','))
    end

    desc 'Auxiliary method used to associate copyright, copyright holder, and collection to Bhutanese material.'
    task :tag_all_media do |t|
      require File.join(File.dirname(__FILE__), "../lib/tag_media.rb")
      TagMedia.tag_current_media
    end

    desc media_extractor_description
    task :media_extractor do |t|
      require File.join(File.dirname(__FILE__), "../lib/media_extractor.rb")
      filename = ENV['FILENAME']
      if filename.blank?
        puts media_extractor_description
      else
        MediaExtractor.extract_metadata(filename)
      end
    end

    desc metadata_description
    task :metadata do |t|
      require File.join(File.dirname(__FILE__), "../lib/media_extractor.rb")
      filename = ENV['FILENAME']
      if filename.blank?
        puts metadata_description
      else
        MetadataImportation.do_metadata_importation(filename)
      end
    end    
  end
  
  namespace :cache do
    cummulative_categories_cleanup_description = "Deletes cummulative information"
    desc cummulative_categories_cleanup_description
    task :cummulative_categories_cleanup do |t|
      [CumulativeMediaCategoryAssociation, CachedCategoryCount].each { |model| model.connection.execute("TRUNCATE TABLE #{model.table_name}") }
      options = {:group =>'category_id', :order => 'category_id'}
      options.merge!({:joins => :medium, :conditions => {'media.application_filter_id' => ApplicationFilter.application_filter.id}}) if !ApplicationFilter.application_filter.nil?
      MediaCategoryAssociation.find(:all, options).collect(&:category).each do |category|
        medium_ids = ApplicationFilter.application_filter.nil? ? MediaCategoryAssociation.find(:all, :conditions => {:category_id => category.id}).collect(&:medium_id) : MediaCategoryAssociation.find(:all, :joins => :medium, :conditions => {:category_id => category.id, 'media.application_filter_id' => ApplicationFilter.application_filter.id}).collect(&:medium_id)
        ([category] + category.ancestors).each { |c| medium_ids.each { |medium_id| CumulativeMediaCategoryAssociation.create(:category => c, :medium_id => medium_id) if CumulativeMediaCategoryAssociation.find(:first, :conditions => {:category_id => c.id, :medium_id => medium_id}).nil? } }
      end
    end
  end
end