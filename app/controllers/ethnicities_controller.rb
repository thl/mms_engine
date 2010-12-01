class EthnicitiesController < AclController
  include HierarchicalMediaBrowse
  helper :media
  
  def initialize
    super
    @guest_perms += ['ethnicities/expand', 'ethnicities/contract' ]
    @model = Ethnicity
  end  
end