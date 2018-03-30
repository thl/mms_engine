class DocumentsController < AclController
  helper :media
  caches_page :show, :if => Proc.new { |c| c.request.format.xml? }
  cache_sweeper :document_sweeper, :only => [:update, :destroy]

  def initialize
    super
    @guest_perms += ['documents/by_title']
  end

  # GET /documents
  # GET /documents.xml
  def index
    title = params[:title]
    if title.blank?
      original_medium_id = params[:original_medium_id]
      @documents = original_medium_id.blank? ? Document.all : Document.joins(:workflow).where('workflows.original_medium_id' => original_medium_id)
    else
      @documents = Document.joins(:titles).where('titles.title' => title) + Document.joins(:titles => :translated_titles).where('translated_titles.title' => title)
    end
    respond_to do |format|
      format.html # index.rhtml
      format.xml  # { render :xml => @documents.to_xml }
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
        format.xml { render 'media/show' }
        format.ris
      end
    end
  end

  # GET /documents/new
  def new
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @medium = Document.new(:resource_type_id => 2639)
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')    
    @resource_types = Topic.find(2636).children
    @transformations = Transformation.order('renderer_id, title')
  end

  # GET /documents/1;edit
  def edit
    @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
    @medium = Document.find(params[:id])
    @photographers = AuthenticatedSystem::Person.order('fullname')
    @quality_types = QualityType.order('id')
    @recording_orientations = RecordingOrientation.order('title')    
    @resource_types = Topic.find(2636).children
    @transformations = Transformation.order('renderer_id, title')
    @root_topics = Topic.roots
    render :template => 'media/edit'
  end

  # POST /documents
  # POST /documents.xml
  def create
    typescript_params = params[:typescript].nil? ? nil : params.require(:typescript).permit(:content_type, :temp_path, :filename, :parent_id, :thumbnail)
    @typescript = nil
    if !typescript_params.nil? && !typescript_params[:uploaded_data].nil?
      @typescript = Typescript.new(typescript_params)
      success = @typescript.save
      has_typescript = true
    else
      has_typescript = false
      success = true
    end
    has_preview = false
    if success
      thumbnail_params = params[:thumbnail].nil? ? nil : params[:thumbnail].permit(:content_type, :temp_path, :filename, :parent_id, :thumbnail)
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
      params_medium = params[:medium].permit(:recording_note, :resource_type_id, :photographer_id, :taken_on,
        :partial_taken_on, :capture_device_model_id, :quality_type_id, :private_note)
      params_medium = document_params if params_medium.nil?
      @medium = Document.new(params_medium)
      @medium.ingest_taken_on(params_medium)
      @medium.typescript = @typescript
      success = @medium.save
    end
    if success
      has_preview = @medium.create_or_update_preview if has_typescript && !has_preview
      @medium.create_thumbnails if has_preview
    end
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Document.model_name.human.capitalize)
        format.html { redirect_to document_url(@medium) }
        format.xml  { head :created, :location => document_url(@medium) }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
          @photographers = AuthenticatedSystem::Person.order('fullname')
          @quality_types = QualityType.order('id')
          @recording_orientations = RecordingOrientation.order('title')    
          @resource_types = Topic.find(2636).children
          @transformations = Transformation.order('renderer_id, title')
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
      if @document.update_attributes(document_params)
        flash[:notice] = ts('edit.successful', :what => Document.model_name.human.capitalize)
        format.html { redirect_to document_url(@document) }
        format.xml  { head :ok }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.order('title').collect{|maker| maker.capture_device_models}.flatten
          @photographers = AuthenticatedSystem::Person.order('fullname')
          @quality_types = QualityType.order('id')
          @recording_orientations = RecordingOrientation.order('title')    
          @resource_types = Topic.find(2636).children
          @transformations = Transformation.order('renderer_id, title')
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
  
  private
  
  def document_params
    params.requre(:document).permit(:typescript, :recording_note, :resource_type_id, :photographer_id,
    :taken_on, :capture_device_model_id, :quality_type_id, :private_note)
  end
end