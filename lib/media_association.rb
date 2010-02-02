module MediaAssociation
  
  def index
    @associations = @medium.media_category_associations.find(:all, :conditions => {:root_id => @model.root_id})
    respond_to do |format|
      format.html { render :template => 'main/hierarchy/associations/index' }
      format.xml  { render :xml => @associations.to_xml }
    end
  end

  def show
    @association = MediaCategoryAssociation.find(params[:id])
    @element = @association.category

    if block_given?
      yield
    else
      respond_to do |format|
        format.html { render :template => 'main/hierarchy/associations/show' }
        format.xml  { render :xml => @association.to_xml }
      end
    end
  end
  
  def new
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to elements_url
    else
      @association = @medium.media_category_associations.new(:root_id => @model.root_id)
      if block_given?
        yield
      else
        render :template => 'main/hierarchy/associations/new'
      end
    end
  end
  
  def edit
    @association = MediaCategoryAssociation.find(params[:id])
    @element = @association.category
    if block_given?
      yield
    else
      render :template => 'main/hierarchy/associations/edit'
    end
  end
  
  def create
    @association = MediaCategoryAssociation.new(params[:association])
    if @association.save
      respond_to do |format|
        flash[:notice] = ts('new.successful', :what => t('associate.ion', :what => t(@model.model_name.underscore)))
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => association_url(@association) }
      end
    else
      if block_given?
        yield
      end
      respond_to do |format|      
        format.html { render :action => 'main/hierarchy/associations/new' }
        format.xml  { render :xml => @association.errors.to_xml }
      end
    end
  end
  
  def update
    @association = MediaCategoryAssociation.find(params[:id])
    if @association.update_attributes(params[:association])
      respond_to do |format|
        flash[:notice] = ts('edit.successful', :what => t('associate.ion', :what => t(@model.model_name.underscore)))
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      end
    else
      if block_given?
        yield
      end
      @element = @association.category
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @association.errors.to_xml }
      end
    end
  end
  
  def destroy
    @association = MediaCategoryAssociation.find(params[:id])
    @association.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_medium
    medium_id = params[:medium_id]
    @medium = medium_id.blank? ? nil : Medium.find(medium_id)
  end
end