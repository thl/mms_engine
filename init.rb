# Include hook code here
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]
sweeper_folder = File.join(File.dirname(__FILE__), 'app', 'sweepers')
require File.join(sweeper_folder, 'document_sweeper')
require File.join(sweeper_folder, 'keyword_sweeper')
require File.join(sweeper_folder, 'media_category_association_sweeper')
require File.join(sweeper_folder, 'medium_sweeper')
require File.join(sweeper_folder, 'place_count_sweeper')
require File.join(sweeper_folder, 'title_sweeper')
require File.join(sweeper_folder, 'word_sweeper')
require File.join(sweeper_folder, 'workflow_sweeper')
require File.join(File.dirname(__FILE__), 'lib', 'mime_types')
# Instead of having this in environment.rb:
# config.active_record.observers = :cached_category_count_sweeper, :place_count_sweeper
# this is how observers are instantiated in plugins (the above doesn't work here at least in rails 2.3.4)
PlaceCountSweeper.instance
WordSweeper.instance
ActionController::Base.cache_store = :file_store, File.join(RAILS_ROOT, 'tmp', 'cache')