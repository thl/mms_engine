module MmsEngine
  class Engine < ::Rails::Engine
    initializer :assets do |config|
      Rails.application.config.assets.precompile.concat(['mms_engine/swfobject.js', 'mms_engine/popup-ui-handler'])
    end
    
    initializer :sweepers do |config|
      sweeper_folder = File.join(File.dirname(__FILE__), '..', '..', 'app', 'sweepers')
      require File.join(sweeper_folder, 'document_sweeper')
      require File.join(sweeper_folder, 'keyword_sweeper')
      require File.join(sweeper_folder, 'media_category_association_sweeper')
      require File.join(sweeper_folder, 'medium_sweeper')
      require File.join(sweeper_folder, 'place_count_sweeper')
      require File.join(sweeper_folder, 'title_sweeper')
      require File.join(sweeper_folder, 'word_sweeper')
      require File.join(sweeper_folder, 'workflow_sweeper')
      # PlaceCountSweeper.instance
      # WordSweeper.instance
      Rails.application.config.active_record.observers = :word_sweeper, :place_count_sweeper
    end
  end
end
