class TransformationsController < AclController
  # GET /transformations
  # GET /transformations.xml
  def index
    @transformations = Transformation.order('title')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @transformations.to_xml }
    end
  end

  # GET /transformations/1
  # GET /transformations/1.xml
  def show
    @transformation = Transformation.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @transformation.to_xml }
    end
  end

  # GET /transformations/new
  def new
    @transformation = Transformation.new
  end

  # GET /transformations/1;edit
  def edit
    @transformation = Transformation.find(params[:id])
  end

  # POST /transformations
  # POST /transformations.xml
  def create
    @transformation = Transformation.new(transformation_params)
    respond_to do |format|
      if @transformation.save
        flash[:notice] = ts('new.successful', :what => Transformation.model_name.human.capitalize)
        format.html { redirect_to transformation_url(@transformation) }
        format.xml  { head :created, :location => transformation_url(@transformation) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transformation.errors.to_xml }
      end
    end
  end

  # PUT /transformations/1
  # PUT /transformations/1.xml
  def update
    @transformation = Transformation.find(params[:id])
    respond_to do |format|
      if @transformation.update_attributes(transformation_params)
        flash[:notice] = ts('edit.successful', :what => Transformation.model_name.human.capitalize)
        format.html { redirect_to transformation_url(@transformation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transformation.errors.to_xml }
      end
    end
  end

  # DELETE /transformations/1
  # DELETE /transformations/1.xml
  def destroy
    @transformation = Transformation.find(params[:id])
    @transformation.destroy
    respond_to do |format|
      format.html { redirect_to transformations_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def transformation_params
    params.require(:transformation).permit(:renderer_id, :title, :path)
  end
end