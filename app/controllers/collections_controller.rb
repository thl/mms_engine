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
