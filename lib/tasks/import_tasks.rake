require 'config/environment'
namespace :mms do
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

    metadata_description = "Task used to import metadata for THL images.\n" +
    "Syntax: rake mms:import:metadata FILENAME=filename\n" +
    "Takes a CSV where first row are the column names. The following column names are accepted and interpreted:\n" +
    "media.id, workflows.original_filename,\n" +
    "workflows.original_medium_id, workflows.other_id, workflows.sequence_order, workflows.notes,\n" +
    "media.recording_note, media.private_note, media.taken_on, media.photographer, recording_orientations.title,\n" +
    "locations.feature_id, geo_code_types.code, features.geo_code, locations.notes, locations.spot_feature,\n" +
    "captions.title,\n" +
    "topics.title | topics.id,\n" +
    "descriptions.title, descriptions.creator,\n" +
    "keywords.title,\n" +
    "sources.title, media_source_associations.shot_number"
    
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

    desc metadata_description
    task :metadata do |t|
      require File.join(File.dirname(__FILE__), "../lib/metadata_importation.rb")
      filename = ENV['FILENAME']
      if filename.blank?
        puts metadata_description
      else
        MetadataImportation.new.do_metadata_importation(filename)
      end
    end    
  end
end