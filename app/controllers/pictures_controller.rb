class PicturesController < AclController
  caches_page :show, :if => Proc.new { |c| c.request.format.xml? }
  cache_sweeper :medium_sweeper, :only => [:update, :destroy]

  # GET /pictures
  # GET /pictures.xml
  def index
    redirect_to media_url
  end

  # GET /pictures/1
  # GET /pictures/1.xml
  def show
    @medium = Picture.find(params[:id])
    if request.xhr?
      render :partial => 'media/show'
    else
      respond_to do |format|
        format.html # show.rhtml
        format.xml #{ render :xml => @medium.to_xml }
      end
    end
  end

  # GET /pictures/new
  def new
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')    
    @resource_types = Topic.find(2636).children
    @medium = Picture.new(:resource_type_id => 2660)
    @image = Image.new
    # render :template => 'media/edit'
  end

  # GET /pictures/1;edit
  def edit
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @medium = Picture.find(params[:id])
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')    
    @resource_types = Topic.find(2636).children
  end

  # POST /pictures
  # POST /pictures.xml
  def create
    begin
      @image = Image.new(params.require(:image).permit(:content_type, :temp_path, :filename, :uploaded_data))
      success = @image.save
    rescue => e
      @image = Image.new if @image.nil?
      success = false
    else
      if success
        params_picture = picture_params
        @medium = Picture.new(params_picture)
        @medium.ingest_taken_on(params_picture)
        @medium.image = @image
        success = @medium.save
      end
    end
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Picture.model_name.human.capitalize)
        format.html { redirect_to picture_url(@medium) }
        format.xml  { head :created, :location => picture_url(@medium) }
      else
        @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
        @photographers = AuthenticatedSystem::Person.order('fullname')
        @quality_types = QualityType.order('id')
        @recording_orientations = RecordingOrientation.order('title')    
        @resource_types = Topic.find(2636).children        
        @medium = Picture.new(params[:medium]) if @medium.nil?
        flash[:notice] = "Picture could not be saved."
        format.html { render :action => "new" }
        format.xml  { render :xml => @medium.errors.to_xml }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.xml
  def update
    @medium = Picture.find(params[:id])
    respond_to do |format|
      if @medium.update_attributes(picture_params)
        flash[:notice] = ts('edit.successful', :what => Picture.model_name.human.capitalize)
        format.html { redirect_to picture_url(@medium) }
        format.xml  { head :ok }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
          @photographers = AuthenticatedSystem::Person.order('fullname')
          @quality_types = QualityType.order('id')
          @recording_orientations = RecordingOrientation.order('title')    
          @resource_types = Topic.find(2636).children          
          render :action => 'edit'
        end
        format.xml  { render :xml => @medium.errors.to_xml }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.xml
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def picture_params
    params.require(:medium).permit(:image, :recording_note, :resource_type_id, :photographer_id, :taken_on,
      :capture_device_model_id, :quality_type_id, :private_note, :rotation, :recording_orientation_id)
  end
end