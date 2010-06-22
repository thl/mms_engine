# Include hook code here
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'config', 'locales', '**', '*.yml')]
require File.join(File.dirname(__FILE__), 'app', 'sweepers', 'title_sweeper')
require File.join(File.dirname(__FILE__), 'app', 'sweepers', 'workflow_sweeper')
require File.join(File.dirname(__FILE__), 'app', 'sweepers', 'cached_category_count_sweeper')