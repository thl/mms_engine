class VideosController < AclController
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

  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @videos.to_xml }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @medium = Video.find(params[:id])
    if !@medium.transcript.nil?
      language = params[:language]
      form = params[:form]
      @transcript_params = {:video_id => @medium.id}
      @transcript_params[:language] = language if !language.nil?
      @transcript_params[:form] = form if !form.nil?
    end
    if request.xhr?
      render :partial => 'media/show'
    else
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @medium.to_xml }
      end
    end
  end

  # GET /videos/new
  def new
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
    @medium = Video.new
  end

  # GET /videos/1;edit
  def edit
    @medium = Video.find(params[:id])
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
    render :template => 'media/edit'
  end

  # POST /videos
  # POST /videos.xml
  def create
    @movie = Movie.new(params[:movie])
    success = @movie.save
    if success
      transcript_params = params[:transcript]
      if !transcript_params.blank?
        transcript_params[:parent_id] = @movie.id
        transcript_params[:thumbnail] = 'transcript'
        transcript = Movie.new(transcript_params)
        success = transcript.save
      end
    end
    if success
      @video = Video.new(params[:video])
      @video.movie = @movie
      success = @video.save 
    end
    @video.process if success
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Video.human_name.capitalize)
        format.html { redirect_to medium_url(@video) }
        format.xml  { head :created, :location => medium_url(@video) }
      else
        format.html do
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
          render :action => 'new'
        end
        format.xml  { render :xml => @video.errors.to_xml }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = ts('edit.successful', :what => Video.human_name.capitalize)
        format.html { redirect_to medium_url(@video) }
        format.xml  { head :ok }
      else
        format.html do
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
          render :action => 'media/edit'
        end
        format.xml  { render :xml => @video.errors.to_xml }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.xml  { head :ok }
    end
  end
end
