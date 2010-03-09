class DocumentsController < AclController
  helper :media

  # GET /documents
  # GET /documents.xml
  def index
    @documents = Document.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @documents.to_xml }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @medium = Document.find(params[:id])
    if request.xhr?
      render :partial => 'media/show'
    else
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @medium.to_xml }
      end
    end
  end

  # GET /documents/new
  def new
    @medium = Document.new
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
  end

  # GET /documents/1;edit
  def edit
    @medium = Document.find(params[:id])
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
    @transformations = Transformation.find(:all, :order => 'renderer_id, title')
    render :template => 'media/edit'
  end

  # POST /documents
  # POST /documents.xml
  def create
    typescript_params = params[:typescript]
    @typescript = nil
    if !typescript_params.nil? && !typescript_params[:uploaded_data].nil?
      @typescript = Typescript.new(params[:typescript])
      success = @typescript.save
      has_typescript = true
    else
      has_typescript = false
      success = true
    end
    has_preview = false
    if success
      thumbnail_params = params[:thumbnail]
      if !thumbnail_params.nil? && !thumbnail_params[:uploaded_data].nil?
        # If thumbnail preview was given, use that as the original preview.
        if has_typescript
          thumbnail_params[:parent_id] = @typescript.id
          thumbnail_params[:thumbnail] = Document::PREVIEW_TYPE.to_s
        end
        thumbnail = Typescript.new(thumbnail_params)
        success = thumbnail.save
        if success
          if has_typescript
            has_preview = true
          else            
            @typescript = thumbnail
            has_typescript = true
          end
        end
      end
    end
    if success
      # creating medium before thumbnail to get id name.
      @medium = Document.new(params[:medium])
      @medium.typescript = @typescript
      success = @medium.save
    end
    if success
      has_preview = @medium.create_preview if has_typescript && !has_preview
      @medium.create_thumbnails if has_preview
    end
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Document.human_name.capitalize)
        format.html { redirect_to document_url(@medium) }
        format.xml  { head :created, :location => document_url(@medium) }
      else
        format.html do
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
          @transformations = Transformation.find(:all, :order => 'renderer_id, title')
          render :action => 'new'
        end
        format.xml  { render :xml => @medium.errors.to_xml }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        flash[:notice] = ts('edit.successful', :what => Document.human_name.capitalize)
        format.html { redirect_to document_url(@document) }
        format.xml  { head :ok }
      else
        format.html do
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
          @transformations = Transformation.find(:all, :order => 'renderer_id, title')
          render :action => 'edit'
        end
        format.xml  { render :xml => @document.errors.to_xml }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.xml  { head :ok }
    end
  end
end
