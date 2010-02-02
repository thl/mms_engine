class CollectionsController < AclController
  include HierarchicalMediaBrowse
  helper :media
  
  def initialize
    super
    @guest_perms += ['collections/expand', 'collections/contract']
    @model = Collection
  end
  
  # GET /collections
  # GET /collections.xml
  def index
    super
  end

  # GET /collections/1
  # GET /collections/1.xml
  def show
    super
  end
  
  # GET /collections/1/list
  # GET /collections/1/list.xml
  def list_by_location
    @collection = Collection.find(params[:id])
    @media = Medium.find(:all, :conditions => {'cumulative_media_category_associations.category_id' => @collection.id, 'media.type' => 'Picture'}, :joins => :cumulative_media_category_associations, :include => :administrative_units, :order => 'media.created_on').select do |m| 
      administrative_units = m.administrative_units
      administrative_units.size>0 && administrative_units.any? { |u| u.is_problematic? }
    end
    
    respond_to do |format|
      format.html # list.html.erb
    end
  end
  
  def expand
    super
  end

  def contract
    super
  end
  
  def get_theme
    super
  end
end
