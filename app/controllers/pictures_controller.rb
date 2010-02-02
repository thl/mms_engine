class PicturesController < AclController
  helper :media

  uses_tiny_mce :options => { 
  								:theme => 'advanced',
  								:editor_selector => 'mceEditor2',
  								:width => '550px',
  								:height => '220px',
  								:theme_advanced_resizing => 'true',
  								:theme_advanced_toolbar_location => 'top', 
  								:theme_advanced_toolbar_align => 'left',
  								:theme_advanced_buttons1 => %w{fullscreen separator bold italic underline strikethrough separator undo redo separator link unlink template formatselect code},
  								:theme_advanced_buttons2 => %w{cut copy paste separator pastetext pasteword separator bullist numlist outdent indent separator  justifyleft justifycenter justifyright justifiyfull separator removeformat  charmap },
  								:theme_advanced_buttons3 => [],
  								:plugins => %w{contextmenu paste media fullscreen template noneditable },				
  								:template_external_list_url => '/templates/templates.js',
  								:noneditable_leave_contenteditable => 'true',
  								:theme_advanced_blockformats => 'p,h1,h2,h3,h4,h5,h6'
  								}

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
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
    @medium = Picture.new
    @image = Image.new
    # render :template => 'media/edit'
  end

  # GET /pictures/1;edit
  def edit
    @medium = Picture.find(params[:id])
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
  end

  # POST /pictures
  # POST /pictures.xml
  def create
    begin
      @image = Image.new(params[:image])
      success = @image.save
    rescue
      @image = Image.new if @image.nil?
      success = false
    else
      if success
        @medium = Picture.new(params[:picture])
        @medium.image = @image
        success = @medium.save
      end
    end
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Picture.human_name.capitalize)
        format.html { redirect_to picture_url(@medium) }
        format.xml  { head :created, :location => picture_url(@medium) }
      else
        @medium = Picture.new(params[:medium]) if @medium.nil?
        flash[:notice] = "Picture could not be saved."
        @photographers = Person.find(:all, :order => 'fullname')
        @quality_types = QualityType.find(:all, :order => 'id')
        @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
        @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
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
      if @medium.update_attributes(params[:picture])
        flash[:notice] = ts('edit.successful', :what => Picture.human_name.capitalize)
        format.html { redirect_to picture_url(@medium) }
        format.xml  { head :ok }
      else
        format.html do
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
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
end
