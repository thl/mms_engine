$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mms_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mms_engine"
  s.version     = MmsEngine::VERSION
  s.authors     = ["Andres Montano"]
  s.email       = ["amontano@virginia.edu"]
  s.homepage    = "mms.thlib.org"
  s.summary     = "TODO: Summary of MmsEngine."
  s.description = "TODO: Description of MmsEngine."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '4.1.14'
  # s.add_dependency "jquery-rails"
  
  s.add_dependency 'mysql2', '0.3.18'
  
  # Use Uglifier as compressor for JavaScript assets
  s.add_dependency 'uglifier', '>= 1.3.0'

  # Use CoffeeScript for .js.coffee assets and views
  s.add_dependency 'coffee-rails', '~> 4.0.0'

  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  s.add_dependency 'turbolinks'

  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  s.add_dependency 'jbuilder', '~> 2.0'
  
  s.add_dependency 'hpricot' #, '>= 0.8.6'
  s.add_dependency 'will_paginate' #, '~> 3.0'

  s.add_dependency 'memcache-client'
  s.add_dependency 'newrelic_rpm'
  s.add_dependency 'annotate', '2.7.2'

  s.add_dependency 'rmagick', '2.15.4'
  
  s.add_dependency 'acts_as_list'
  s.add_dependency 'in_place_editing'
  s.add_dependency 'globalize'
  s.add_dependency 'acts_as_versioned'
  s.add_dependency 'permalink_fu'
end
