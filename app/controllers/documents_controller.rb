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
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')    
    @transformations = Transformation.find(:all, :order => 'renderer_id, title')
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
    @typescript = Typescript.new(params[:typescript])
    success = @typescript.save
    if success
      thumbnail_params = params[:thumbnail]
      thumbnail_params[:parent_id] = @typescript.id
      thumbnail_params[:thumbnail] = 'normal'
      thumbnail = Typescript.new(thumbnail_params)
      success = thumbnail.save
    end
    if success
      full_filename = thumbnail.full_filename
      thumb_img = Magick::Image.read(full_filename).first
      thumb_img.change_geometry!('75') { |cols, rows, img| img.resize!(cols, rows) }
      pos = full_filename.rindex('.')
      new_full_filename = full_filename[0...pos] + '_thumb' + full_filename[pos...full_filename.size]
      thumb_img.write new_full_filename
      
      filename = thumbnail.filename
      pos = filename.rindex('.')
      new_filename = filename[0...pos] + '_thumb' + filename[pos...filename.size]      
      
      Typescript.create :content_type => 'image/jpeg', :filename => new_filename, :size => thumb_img.filesize, :parent_id => @typescript.id, :thumbnail => 'thumb', :width => thumb_img.columns, :height => thumb_img.rows 

      @medium = Document.new(params[:medium])
      @medium.typescript = @typescript
      success = @medium.save
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
