module HierarchicalMixedBrowse
   def index
    medium_id = params[:medium_id]
    element_id = params[@element_name.to_sym]
    type = params[:type]
    @medium = nil
    @media = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      else
        @associations = @association_model.find_all_by_medium(@medium)
      end
    end
    no_media = true
    if !element_id.blank?
      begin
        @element = @model.find(element_id)
      rescue ActiveRecord::RecordNotFound
        @current = nil
        @media = nil
      else
        descendant_ids = @element.descendants
        no_media = false
        if type.blank?
          @pictures = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
          @videos = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
          @documents = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
          title = @element.title
          @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
          @more = { @element_name.to_sym => element_id, :type => '' }  
        else
         @medium_pages = Paginator.new self, @model.count_media(descendant_ids), Medium::ROWS * Medium::COLS, params[:page]
         @media = @element.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset)
         @pagination_params = { @element_name.to_sym => @element.id }
         @pagination_prev_url = { @element_name.to_sym => @element.id, :page => @medium_pages.current.previous }
         @pagination_next_url = { @element_name.to_sym => @element.id, :page => @medium_pages.current.next }
         @title = "Media in #{@element.title}"
        end
        if @medium.nil?
          @current = @element.ancestors.collect{|c| c.id}
          @current << @element.id
        end
      end
    end
    yield(no_media)
  end

  def show
    @association = @association_model.find(params[:id])
    @medium = @association.medium
    @element = @association.element    
    yield
  end
  
  def new
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to elements_url
    else
      @association = @association_model.new(:medium => @medium)
      yield
    end
  end
  
  def edit
    @association = @association_model.find(params[:id])
    @medium = @association.medium
    @element = @association.element
    yield
  end
  
  def create
    @association = @association_model.new(params[:association])
    @medium = @association.medium
    if @association.save
      respond_to do |format|
        flash[:notice] = ts('new.successful', :what => MediaAdministrativeLocation.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => association_url(@association) }
      end
    else
      if block_given?
        yield
      else
        @elements = @model.titles_with_ancestors
      end
      @association = @association_model.new(:medium => @medium)
      respond_to do |format|      
        format.html { render :action => 'new' }
        format.xml  { render :xml => @association.errors.to_xml }
      end
    end
  end
  
  def update
    @association = @association_model.find(params[:id])
    @medium = @association.medium

    if @association.update_attributes(params[:association])
      respond_to do |format|
        flash[:notice] = ts('edit.successful', :what => MediaAdministrativeLocation.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      end
    else
      @medium = @association.medium
      if block_given?
        yield
      else
        @elements = @model.titles_with_ancestors
      end
      @element = @association.element
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @association.errors.to_xml }
      end
    end
  end
  
  def destroy
    @association = @association_model.find(params[:id])
    @medium = @association.medium
    @association.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
  
  def expand_unit
    @element = @model.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
    if block_given?
      yield
    else
      render :partial => 'main/hierarchy/mixed_associations/expanded'
    end
  end

  def contract_unit
    @element = @model.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
    if block_given?
      yield
    else
      render :partial => 'main/hierarchy/mixed_associations/contracted'
    end
  end
end