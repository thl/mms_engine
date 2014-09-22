class DescriptionTypesController < AclController
  # GET /description_types
  # GET /description_types.xml
  def index
    @description_types = DescriptionType.order('title')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @description_types.to_xml }
    end
  end

  # GET /description_types/1
  # GET /description_types/1.xml
  def show
    @description_type = DescriptionType.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @description_type.to_xml }
    end
  end

  # GET /description_types/new
  def new
    @description_type = DescriptionType.new
  end

  # GET /description_types/1;edit
  def edit
    @description_type = DescriptionType.find(params[:id])
  end

  # POST /description_types
  # POST /description_types.xml
  def create
    @description_type = DescriptionType.new(description_type_params)

    respond_to do |format|
      if @description_type.save
        flash[:notice] = ts('new.successful', :what => DescriptionType.model_name.human(:what => Description.model_name.human).capitalize)
        format.html { redirect_to description_type_url(@description_type) }
        format.xml  { head :created, :location => description_type_url(@description_type) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @description_type.errors.to_xml }
      end
    end
  end

  # PUT /description_types/1
  # PUT /description_types/1.xml
  def update
    @description_type = DescriptionType.find(params[:id])

    respond_to do |format|
      if @description_type.update_attributes(description_type_params)
        flash[:notice] =ts('edit.successful', :what => DescriptionType.model_name.human(:what => Description.model_name.human).capitalize)
        format.html { redirect_to description_type_url(@description_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @description_type.errors.to_xml }
      end
    end
  end

  # DELETE /description_types/1
  # DELETE /description_types/1.xml
  def destroy
    @description_type = DescriptionType.find(params[:id])
    @description_type.destroy

    respond_to do |format|
      format.html { redirect_to description_types_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def description_type_params
    params.require(:description_type).permit(:title)
  end
end
