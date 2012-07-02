class RenderersController < AclController
  # GET /renderers
  # GET /renderers.xml
  def index
    @renderers = Renderer.order('title')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @renderers.to_xml }
    end
  end

  # GET /renderers/1
  # GET /renderers/1.xml
  def show
    @renderer = Renderer.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @renderer.to_xml }
    end
  end

  # GET /renderers/new
  def new
    @renderer = Renderer.new
  end

  # GET /renderers/1;edit
  def edit
    @renderer = Renderer.find(params[:id])
  end

  # POST /renderers
  # POST /renderers.xml
  def create
    @renderer = Renderer.new(params[:renderer])
    respond_to do |format|
      if @renderer.save
        flash[:notice] = ts('new.successful', :what => Renderer.human_name.capitalize)
        format.html { redirect_to renderer_url(@renderer) }
        format.xml  { head :created, :location => renderer_url(@renderer) }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @renderer.errors.to_xml }
      end
    end
  end

  # PUT /renderers/1
  # PUT /renderers/1.xml
  def update
    @renderer = Renderer.find(params[:id])
    respond_to do |format|
      if @renderer.update_attributes(params[:renderer])
        flash[:notice] = ts('edit.successful', :what => Renderer.human_name.capitalize)
        format.html { redirect_to renderer_url(@renderer) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @renderer.errors.to_xml }
      end
    end
  end

  # DELETE /renderers/1
  # DELETE /renderers/1.xml
  def destroy
    @renderer = Renderer.find(params[:id])
    @renderer.destroy
    respond_to do |format|
      format.html { redirect_to renderers_url }
      format.xml  { head :ok }
    end
  end
end