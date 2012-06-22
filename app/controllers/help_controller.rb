class HelpController < AclController
  def initialize
    super
    @guest_perms += ['help/advanced_search']
  end
  
  def advanced_search
  end # advanced_search.js.erb
end