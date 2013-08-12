class VideosController < AclController
  helper :media

  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all
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
    respond_to do |format|
      format.html # show.rhtml
      format.js
      format.xml  { render :xml => @medium.to_xml }
    end
  end

  # GET /videos/new
  def new
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @medium = Video.new(:resource_type_id => 2687)
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')
    @resource_types = Topic.find(2636).children
  end

  # GET /videos/1;edit
  def edit
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @medium = Video.find(params[:id])
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')          
    @resource_types = Topic.find(2636).children
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
      params_video = params[:video]
      @medium = Video.new(params[:video])
      @medium.ingest_taken_on(params_video)
      @medium.movie = @movie
      success = @medium.save 
    end
    @medium.process if success
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Video.model_name.human.capitalize)
        format.html { redirect_to medium_url(@medium) }
        format.xml  { head :created, :location => medium_url(@medium) }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
          @photographers = AuthenticatedSystem::Person.order('fullname')
          @quality_types = QualityType.order('id')
          @recording_orientations = RecordingOrientation.order('title')
          @resource_types = Topic.find(2636).children
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
        flash[:notice] = ts('edit.successful', :what => Video.model_name.human.capitalize)
        format.html { redirect_to medium_url(@video) }
        format.xml  { head :ok }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
          @photographers = AuthenticatedSystem::Person.order('fullname')
          @quality_types = QualityType.order('id')
          @recording_orientations = RecordingOrientation.order('title')          
          @resource_types = Topic.find(2687).children          
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