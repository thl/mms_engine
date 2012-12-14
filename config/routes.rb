Rails.application.routes.draw do
  root :to => 'media#index'
  resources :application_settings, :copyrights, :copyright_holders, :description_types, :dictionary_searches,
    :application_filters, :glossaries, :keywords, :media_keyword_associations, :media_searches,
    :organizations, :pictures, :projects, :quality_types, :recording_orientations, :reproduction_types,
    :sources, :sponsors, :transformations, :videos, :statuses, :publishers  
  match 'admin' => 'main#admin', :as => 'admin'
  match 'subtitles/:video_id/:language/:form' => 'subtitles#index', :as => 'subtitles', :defaults => { :form => 'script', :language => 'bo' }
  match 'help' => 'help#advanced_search', :as => 'help_advanced_search'
  
  resources :capture_device_makers do
    resources :models, :controller => 'capture_device_models'
  end
  resources :categories do
    member do
      get :contract
      get :expand
    end
    resources :children, :controller => 'categories' do
      member do
        get :contract
        get :expand
      end
    end
    resources :counts, :controller => 'cached_category_counts', :only => 'index'
  end
  resources :documents do
    match 'by_title/:title.:format' => 'documents#by_title'
  end
  resources :media_objects, :as => 'media', :controller => :media do
    resources :affiliations, :captions, :descriptions, :locations, :places
    resources :associations, :controller => 'media_category_associations'
    resource :media_publisher, :workflow
    collection do
      get :rename_all
      post :goto
    end
    member do
      get :rename
      get :large
      get :full_size
    end
    resources :rotations, :only => [:index, :show, :create] do
      collection { get :status }
    end
    resources :topics do
      resources :associations, :controller => 'media_category_associations'
    end
    resources :source_associations, :controller => 'media_source_associations'
    resources :titles do
      resources :citations
      resources(:translations, :as => 'translated_titles', :controller => :translated_titles) { resources :citations }
    end
    resources :topic_associations, :controller => 'media_category_associations'
  end
  resources :media_imports do
    collection do
      get :status
      post :confirm
    end
  end
  resources :media_processes do
    collection { get :status }
  end
  resources :places do  
    member do
      get :pictures
      get :documents
      get :videos
    end
    resources :counts, :controller => 'place_counts', :only => 'index'
  end
  resources :renderers, :controller => 'file_renderers'
  resources :topics do
    member do
      get :contract
      get :expand
      get :pictures
      get :documents
      get :videos
    end
  end
  resources(:videos) { member { match 'subtitles/:language/:form' => 'videos#show', :as => 'subtitles', :defaults => { :form => 'script', :language => 'bo' } } }
  #match ':controller(/:action(/:id(.:format)))'
  comatose_admin
  # comatose_root 'ndlb/pages'  
end