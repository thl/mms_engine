# Include hook code here
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]
sweeper_folder = File.join(File.dirname(__FILE__), 'app', 'sweepers')
require File.join(sweeper_folder, 'cached_category_count_sweeper')
require File.join(sweeper_folder, 'document_sweeper')
require File.join(sweeper_folder, 'medium_sweeper')
require File.join(sweeper_folder, 'place_count_sweeper')
require File.join(sweeper_folder, 'title_sweeper')
require File.join(sweeper_folder, 'workflow_sweeper')
# Instead of having this in environment.rb:
# config.active_record.observers = :cached_category_count_sweeper, :place_count_sweeper
# this is how observers are instantiated in plugins (the above doesn't work here at least in rails 2.3.4)
CachedCategoryCountSweeper.instance
PlaceCountSweeper.instance