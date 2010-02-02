class ReproductionTypesController < AclController
  # GET /reproduction_types
  # GET /reproduction_types.xml
  def index
    @reproduction_types = ReproductionType.find(:all, :order => '`order`')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @reproduction_types.to_xml }
    end
  end

  # GET /reproduction_types/1
  # GET /reproduction_types/1.xml
  def show
    @reproduction_type = ReproductionType.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @reproduction_type.to_xml }
    end
  end

  # GET /reproduction_types/new
  def new
    order = ReproductionType.maximum('`order`')
    if order.nil?
      order_number = 1
    else
      order_number = order.to_i + 1
    end
    @reproduction_type = ReproductionType.new(:order => order_number)
  end

  # GET /reproduction_types/1;edit
  def edit
    @reproduction_type = ReproductionType.find(params[:id])
  end

  # POST /reproduction_types
  # POST /reproduction_types.xml
  def create
    @reproduction_type = ReproductionType.new(params[:reproduction_type])

    respond_to do |format|
      if @reproduction_type.save
        flash[:notice] = ts('new.successful', :what => ReproductionType.human_name.capitalize)
        format.html { redirect_to reproduction_type_url(@reproduction_type) }
        format.xml  { head :created, :location => reproduction_type_url(@reproduction_type) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @reproduction_type.errors.to_xml }
      end
    end
  end

  # PUT /reproduction_types/1
  # PUT /reproduction_types/1.xml
  def update
    @reproduction_type = ReproductionType.find(params[:id])

    respond_to do |format|
      if @reproduction_type.update_attributes(params[:reproduction_type])
        flash[:notice] = ts('edit.successful', :what => ReproductionType.human_name.capitalize)
        format.html { redirect_to reproduction_type_url(@reproduction_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @reproduction_type.errors.to_xml }
      end
    end
  end

  # DELETE /reproduction_types/1
  # DELETE /reproduction_types/1.xml
  def destroy
    @reproduction_type = ReproductionType.find(params[:id])
    @reproduction_type.destroy

    respond_to do |format|
      format.html { redirect_to reproduction_types_url }
      format.xml  { head :ok }
    end
  end
end
