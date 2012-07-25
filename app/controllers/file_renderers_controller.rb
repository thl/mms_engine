class FileRenderersController < AclController
  # GET /renderers
  # GET /renderers.xml
  def index
    @file_renderers = FileRenderer.order('title')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @file_renderers.to_xml }
    end
  end

  # GET /renderers/1
  # GET /renderers/1.xml
  def show
    @file_renderer = FileRenderer.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @file_renderer.to_xml }
    end
  end

  # GET /renderers/new
  def new
    @file_renderer = FileRenderer.new
  end

  # GET /renderers/1;edit
  def edit
    @file_renderer = FileRenderer.find(params[:id])
  end

  # POST /renderers
  # POST /renderers.xml
  def create
    @file_renderer = FileRenderer.new(params[:renderer])
    respond_to do |format|
      if @file_renderer.save
        flash[:notice] = ts('new.successful', :what => FileRenderer.model_name.human.capitalize)
        format.html { redirect_to renderer_url(@file_renderer) }
        format.xml  { head :created, :location => renderer_url(@file_renderer) }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @file_renderer.errors.to_xml }
      end
    end
  end

  # PUT /renderers/1
  # PUT /renderers/1.xml
  def update
    @file_renderer = FileRenderer.find(params[:id])
    respond_to do |format|
      if @file_renderer.update_attributes(params[:renderer])
        flash[:notice] = ts('edit.successful', :what => FileRenderer.model_name.human.capitalize)
        format.html { redirect_to renderer_url(@file_renderer) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @file_renderer.errors.to_xml }
      end
    end
  end

  # DELETE /renderers/1
  # DELETE /renderers/1.xml
  def destroy
    @file_renderer = FileRenderer.find(params[:id])
    @file_renderer.destroy
    respond_to do |format|
      format.html { redirect_to renderers_url }
      format.xml  { head :ok }
    end
  end
end