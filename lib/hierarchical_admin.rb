module HierarchicalAdmin
  def index
    @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
    respond_to do |format|
      format.html { render :template => 'main/hierarchy/admin/index' }
      format.xml do
        @dtd = controller_name
        render :template => 'main/hierarchy/admin/index', :layout => 'application'
      end
    end
  end
  
  def show
    @element = @model.find(params[:id])
    if request.xhr?
      @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
      @margin_depth = @element.ancestors.size
      @current = @element.ancestors.collect{|c| c.id}
      @current << @element.id
      render :update do |page|
        page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        page.replace_html 'content-main', :partial => 'main/hierarchy/admin/show'
      end
    else
      if block_given?
        yield
      else
        respond_to do |format|
          format.html { render :template => 'main/hierarchy/admin/show' }
          format.xml  do
            @dtd = controller_name.singularize
            render :template => 'main/hierarchy/admin/show', :layout => 'application'
          end
        end
      end
    end
  end
  
  def destroy
    @element = @model.find(params[:id])
    title = @element.title
    @child = @element.parent
    @element.destroy
    @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
    if request.xhr?
      render :update do |page|
        page.replace_html 'content-main', ('%s deleted succesfully.'/title).s
        if @child.nil?
          page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        else
          @margin_depth = @child.ancestors.size
          page.replace_html "#{@child.id}_div", :partial => 'main/hierarchy/admin/expanded'
        end
      end          
    else
      respond_to do |format|
        format.html { redirect_to elements_url }
        format.xml  { head :ok }
      end
    end
  end

  def expand
    @child = @model.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
    render :partial => 'main/hierarchy/admin/expanded'
  end

  def contract
    @child = @model.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
    render :partial => 'main/hierarchy/admin/contracted'
  end
  
  def new
    parent_id = params[:parent_id]
    if !parent_id.blank?
      @parent = @model.find(parent_id)
    else
      @parent = nil
    end
    order = @model.maximum('`order`', :conditions => {:parent_id => @parent} ).to_i
    if order.nil?
      highest_order = 1
    else
      highest_order = order + 1
    end
    @element = @model.new(:parent => @parent, :order => highest_order, :creator => current_user.person)
    if block_given?
      yield
    else
      if request.xhr?
        render :partial => 'main/hierarchy/admin/new'
      else
        render :template => 'main/hierarchy/admin/new'
      end
    end
  end
  
  def edit
    @element = @model.find(params[:id])
    @elements = @model.titles_with_ancestors
    if block_given?
      yield
    else    
      if request.xhr?
        render :partial => 'main/hierarchy/admin/edit'
      else
        render :template => 'main/hierarchy/admin/edit'
      end
    end
  end
  
  def create
    @element = @model.new(params[:element])    
    if @element.save
      flash[:notice] = '%s was successfully created.'/@human_name.capitalize
      if request.xhr?
        @child = @element.parent
        @current = [@element.id]
        @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
        render :update do |page|
          page.replace_html 'secondary', :partial => 'main/hierarchy/admin/show'
          if @child.nil?
            page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
          else
            @margin_depth = @child.ancestors.size
            page.replace_html "#{@child.id}_div", :partial => 'main/hierarchy/admin/expanded'
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to @element.parent.nil? ? elements_url : element_url(@element.parent) }
          format.xml  { head :created, :location => element_url(@element) }
        end
      end
    else
      if block_given?
        yield
      else
        if request.xhr?
          render(:update) {|page| page.replace_html 'secondary', :partial => 'main/hierarchy/admin/new'}
        else      
          respond_to do |format|
            format.html { render :action => 'new' }
            format.xml  { render :xml => @element.errors.to_xml }
          end
        end
      end
    end
  end
  
  def update
    @element = @model.find(params[:id])
    parent = @element.parent
    if @element.update_attributes(params[:element])
      flash[:notice] = '%s was successfully updated.'/@human_name
      if request.xhr?
        @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')                
        render(:update) do |page|
          page.replace_html 'secondary', :partial => 'main/hierarchy/admin/show'
          @element.reload
          @current = @element.ancestors.collect{|c| c.id}
          @current << @element.id
          page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        end
      else
        respond_to do |format|
          format.html { redirect_to element_url(@element) }
          format.xml  { head :ok }
        end
      end
    else
      @elements = @model.find(:all, :conditions => {:parent_id => nil}, :order => 'title')
      if block_given?
        yield
      else
        if request.xhr?
          render :partial => 'main/hierarchy/admin/edit'
        else
          respond_to do |format|
            format.html { render :action => 'edit' }
            format.xml  { render :xml => @element.errors.to_xml }
          end
        end
      end
    end    
  end
end