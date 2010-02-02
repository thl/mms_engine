class SubjectsController < AclController
  include HierarchicalMediaBrowse
  helper :media

  def initialize
    super
    @guest_perms += ['subjects/expand', 'subjects/contract' ]
    @model = Subject
  end
  
  # GET /subjects
  # GET /subjects.xml
  def index
    super
  end

  # GET /subjects/1
  # GET /subjects/1.xml
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