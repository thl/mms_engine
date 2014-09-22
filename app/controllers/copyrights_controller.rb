class CopyrightsController < AclController
  # GET /copyrights
  # GET /copyrights.xml
  def index
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to media_path
    else
      @copyright_holders = CopyrightHolder.order('title')
      @reproduction_types = ReproductionType.order('`order`')
      @copyrights = @medium.copyrights
      
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @captions.to_xml }
      end
    end
  end

  # GET /copyrights/1
  # GET /copyrights/1.xml
  def show
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
    @copyright_holder = @copyright.copyright_holder
    @reproduction_type = @copyright.reproduction_type
    
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @caption.to_xml }
    end
  end

  # GET /copyrights/new
  def new
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to media_path
    else
      @copyright_holders = CopyrightHolder.order('title')
      @reproduction_types = ReproductionType.order('`order`')
      @copyright = Copyright.new(:medium => @medium)
    end
  end

  # GET /copyrights/1;edit
  def edit
    @copyright_holders = CopyrightHolder.order('title')
    @reproduction_types = ReproductionType.order('`order`')
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
  end

  # POST /copyrights
  # POST /copyrights.xml
  def create
    @copyright = Copyright.new(copyright_params)
    @medium = @copyright.medium

    respond_to do |format|
      if @copyright.save
        flash[:notice] = ts('new.successful', :what => Copyright.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => copyright_url(@copyright) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @copyright.errors.to_xml }
      end
    end
  end

  # PUT /copyrights/1
  # PUT /copyrights/1.xml
  def update
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium

    respond_to do |format|
      if @copyright.update_attributes(copyright_params)
        flash[:notice] = ts('edit.successful', :what => Copyright.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @copyright.errors.to_xml }
      end
    end
  end

  # DELETE /copyrights/1
  # DELETE /copyrights/1.xml
  def destroy
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
    @copyright.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def copyright_params
    params.require(:copyright).permit(:medium_id, :copyright_holder_id, :reproduction_type_id, :notes)
  end
end