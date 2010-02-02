class MainController < AclController
  def initialize
    super
    @guest_perms += ['main/ims', 'main/change_language', 'main/login', 'main/logout', 'main/banner_start', 'main/banner_end']
  end

  def index
    # render :action => "index"
  end
  
  def admin
  end
  
  def banner_start
    render :partial => "main/banner_start"
  end

  def banner_end
    render :partial => 'main/banner_end'
  end  
end