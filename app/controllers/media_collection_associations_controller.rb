class MediaCollectionAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media
  
  def initialize
    super
    @model = Collection
  end
      
  private
    
  def elements_url
    collections_url
  end
  
  def association_url(association)
    medium_collection_association_url(@medium, association)
  end
end