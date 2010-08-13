ActionController::Routing::Routes.draw do |map|
  map.admin 'admin', :controller => 'main', :action => 'admin'
  map.root :controller => 'media', :action => 'index'
    
  map.subtitles 'subtitles/:video_id/:language/:form', :defaults => {:language => 'bo', :form => 'script'}, :controller => 'subtitles', :action => 'index'
  map.video_subtitles 'videos/:id/subtitles/:language/:form', :defaults => {:language => 'bo', :form => 'script'}, :controller => 'videos', :action => 'show'
  
  map.resources :capture_device_makers do |maker| #, :has_many => :capture_device_models
    maker.resources :models, :controller => 'capture_device_models'
  end    
  map.resources(:categories, :member => {:expand => :get, :contract => :get}) do |category|
    category.resources(:children, :controller => 'categories', :member => {:expand => :get, :contract => :get})
    category.resources(:counts, :controller => 'cached_category_counts')
  end
  map.resources :collections, :member => {:expand => :get, :contract => :get, :list_by_location => :get}
  map.permalink 'collection/:permalink', :controller => 'collections', :action => 'permalink'
  
  map.resources :countries, :has_many => :administrative_levels do |country|
    country.resources :administrative_units, :member => {:expand => :get, :contract => :get}
  end
  
  map.resources :ethnicities, :member => {:expand => :get, :contract => :get}
  map.resources :subjects, :member => {:expand => :get, :contract => :get}
  
  map.resources :media, :as => 'media_objects', :member => { :full_size => :get, :large => :get, :rename => :get }, :collection => { :rename_all => :get }, :has_many => [:affiliations, :captions, :collections, :descriptions, :ethnicities, :locations, :places, :subjects] do |media|
    media.resources :source_associations, :controller => 'media_source_associations'
    media.resources :collection_associations, :controller => 'media_collection_associations'
    media.resources :subject_associations, :controller => 'media_subject_associations'
    media.resources :ethnicity_associations, :controller => 'media_ethnicity_associations'
    media.resources :titles do |title| 
      title.resources :citations
      title.resources :translated_titles, :as => 'translations' do |translated_title|
        translated_title.resources :citations
 		  end
    end
    media.resource :workflow

  end
  map.resources :media_imports, :collection => { :confirm => :post, :status => :get }
  map.resources :media_processes, :collection => { :status => :get }
    
  # map.resources :tasks, :collection => {:create_file => :post}, :new => {:file => :get}
  
  map.resources :application_settings, :copyrights, :copyright_holders, :description_types, :dictionary_searches,
  :documents, :application_filters, :glossaries, :keywords, :media_keyword_associations, :media_searches,
  :organizations, :pictures, :places, :projects, :quality_types, :recording_orientations, :renderers,
  :reproduction_types, :sources, :sponsors, :transformations, :videos, :statuses
  
  map.with_options :path_prefix => 'documents', :controller => 'documents' do |documents|
    documents.by_title 'by_title/:title.:format', :action => 'by_title'
  end
  
  map.comatose_admin
  map.comatose_root 'ndlb/pages'  
end