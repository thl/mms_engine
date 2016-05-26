class Session
  include ActiveModel::Model
  attr_accessor :filter
  
  FILTERS_HASH = {no_filter: 'No filter', no_caption: 'No caption', no_description: 'No description', no_place: 'No place', no_subject: 'No subject'}
end
