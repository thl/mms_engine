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
    @typescript = Typescript.new(params[:typescript])
    success = @typescript.save
    if success
      thumbnail_params = params[:thumbnail]
      thumbnail_params[:parent_id] = @typescript.id
      thumbnail_params[:thumbnail] = 'preview'
      thumbnail = Typescript.new(thumbnail_params)
      success = thumbnail.save
    end
    if success
      # creating medium before thumbnail to get id name.
      @medium = Document.new(params[:medium])
      @medium.typescript = @typescript
      success = @medium.save
      if success
        # first create essay image
        thumbnail.reload
        full_filename = @typescript.full_filename
        pos = full_filename.rindex('.')
        main_full_beginning = full_filename[0...pos]
        filename = @typescript.filename
        pos = filename.rindex('.')
        main_beginning = filename[0...pos]
        [:essay, :compact].each do |type|
          # get image settings
          image_settings = Medium::COMMON_SIZES[type]
          pos = image_settings.index(':')
          if !pos.nil?
            quality = image_settings[0...pos].to_i
            size = image_settings[pos+1...image_settings.size]
          end
          # fetching preview image
          thumb_img = Magick::Image.read(thumbnail.full_filename).first
          if size[size.size-1]==35 # numeral sign
            size.downcase!
            pos = size.index('x')
            thumb_img.crop_resized!(size[0...pos].to_i, size[pos+1...size.size-1].to_i)
          else            
            thumb_img.change_geometry(size) { |cols, rows, image| image.resize!(cols<1 ? 1 : cols, rows<1 ? 1 : rows) }
          end
          # write file
          filename_ending = "_#{type.to_s}.jpg"
          full_path = main_full_beginning + filename_ending
          thumb_img.write(full_path) do
            self.quality = quality if !quality.nil?
            self.format = 'JPG'
          end
          # create db record
          typescript = Typescript.create :content_type => 'image/jpeg', :filename => main_beginning + filename_ending, :size => File.size(full_path), :parent_id => @typescript.id, :thumbnail => type.to_s, :width => thumb_img.columns, :height => thumb_img.rows    
        end
      end
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
