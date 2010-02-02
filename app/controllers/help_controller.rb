class HelpController < AclController
  def initialize
    super
    @guest_perms += ['help/advanced_search']
  end
  
  def advanced_search
    render(:partial => 'advanced_search') if request.xhr? 
  end
end