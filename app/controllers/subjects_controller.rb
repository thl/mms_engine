class SubjectsController < AclController
  include HierarchicalMediaBrowse
  helper :media

  def initialize
    super
    @guest_perms += ['subjects/expand', 'subjects/contract' ]
    @model = Subject
  end
end