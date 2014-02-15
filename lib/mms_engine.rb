require 'mms_engine/engine'
require 'forked_notifier'
require 'util'
require 'media_processor'
require 'spelling'
require 'filename_utils'

# Include hook code here
# I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales')
I18n.load_path += Dir[File.join(__dir__, '..', 'config', 'locales', '**', '*.yml')]
require 'mime_types'
# ActionController::Base.cache_store = :file_store, File.join(RAILS_ROOT, 'tmp', 'cache')

module MmsEngine
end
