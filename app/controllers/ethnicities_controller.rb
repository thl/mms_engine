class EthnicitiesController < AclController
  include HierarchicalMediaBrowse
  helper :media
  
  def initialize
    super
    @guest_perms += ['ethnicities/expand', 'ethnicities/contract' ]
    @model = Ethnicity
  end
  
  # GET /ethnicities
  # GET /ethnicities.xml
  def index
    super
  end

  # GET /ethnicities/1
  # GET /ethnicities/1.xml
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