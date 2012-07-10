class LocationsController < AclController
  helper :media
  before_filter :find_medium
    
  # GET /locations/1;edit
  def edit
    @location = Location.find(params[:id])
  end
  
  # GET /locations/new
  def new
    @location = @medium.locations.new
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = @medium.locations.new(params[:location])
    if @location.save
      respond_to do |format|
        flash[:notice] = ts('new.successful', :what => Location.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'locations') }
        format.xml  { head :created, :location => location_url(@location) }
      end
    else
      respond_to do |format|      
        format.html { render :action => 'new' }
        format.xml  { render :xml => @location.errors.to_xml }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    if @location.update_attributes(params[:location])
      respond_to do |format|
        flash[:notice] = ts('edit.successful', :what => Location.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'locations') }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @association.errors.to_xml }
      end
    end
  end
  
  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @location.to_xml }
    end    
  end
  
  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium, :anchor => 'locations') }
      format.xml  { head :ok }
    end
  end
  
  # GET /locations
  # GET /locations.xml
  def index
    @locations = @medium.locations
    respond_to do |format|
      format.html # index.rhtml
      format.xml { render :xml => @locations.to_xml }
    end
  end
    
  private
  
  def find_medium
    begin
      medium_id = params[:medium_id]
      @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    rescue ActiveRecord::RecordNotFound
      @medium = nil
    end
    if @medium.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end