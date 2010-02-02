class MediaCollectionAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media
  
  def initialize
    super
    @model = Collection
  end
  
  # GET /media_collection_associations
  # GET /media_collection_associations.xml
  def index
    super
  end
  
  # GET /media_collection_associations/1
  # GET /media_collection_associations/1.xml
  def show
    super
  end

  # GET /media_collection_associations/new
  def new
    super
  end

  # GET /media_collection_associations/1;edit
  def edit
    super
  end

  # POST /media_collection_associations
  # POST /media_collection_associations.xml
  def create
    super
  end

  # PUT /media_collection_associations/1
  # PUT /media_collection_associations/1.xml
  def update
    super
  end

  # DELETE /media_collection_associations/1
  # DELETE /media_collection_associations/1.xml
  def destroy
    super
  end
    
  private
    
  def elements_url
    collections_url
  end
  
  def association_url(association)
    medium_collection_association_url(@medium, association)
  end
end