class QualityTypesController < AclController
  # GET /quality_types
  # GET /quality_types.xml
  def index
    @quality_types = QualityType.order('title')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @quality_types.to_xml }
    end
  end

  # GET /quality_types/1
  # GET /quality_types/1.xml
  def show
    @quality_type = QualityType.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @quality_type.to_xml }
    end
  end

  # GET /quality_types/new
  def new
    @quality_type = QualityType.new
  end

  # GET /quality_types/1;edit
  def edit
    @quality_type = QualityType.find(params[:id])
  end

  # POST /quality_types
  # POST /quality_types.xml
  def create
    @quality_type = QualityType.new(quality_type_params)
    respond_to do |format|
      if @quality_type.save
        flash[:notice] = ts('new.successful', :what => QualityType.model_name.human.capitalize)
        format.html { redirect_to quality_type_url(@quality_type) }
        format.xml  { head :created, :location => quality_type_url(@quality_type) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @quality_type.errors.to_xml }
      end
    end
  end

  # PUT /quality_types/1
  # PUT /quality_types/1.xml
  def update
    @quality_type = QualityType.find(params[:id])

    respond_to do |format|
      if @quality_type.update_attributes(quality_type_params)
        flash[:notice] = ts('edit.successful', :what => QualityType.model_name.human.capitalize)
        format.html { redirect_to quality_type_url(@quality_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @quality_type.errors.to_xml }
      end
    end
  end

  # DELETE /quality_types/1
  # DELETE /quality_types/1.xml
  def destroy
    @quality_type = QualityType.find(params[:id])
    @quality_type.destroy
    respond_to do |format|
      format.html { redirect_to quality_types_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def quality_type_params
    params.require(:quality_type).permit(:title)
  end
end