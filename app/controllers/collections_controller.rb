class CollectionsController < AclController
  include HierarchicalMediaBrowse
  helper :media
  
  def initialize
    super
    @guest_perms += ['collections/expand', 'collections/contract']
    @model = Collection
  end  
end
