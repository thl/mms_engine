class MetadataSourcesController < AclController
  def initialize
    super
    @guest_perms = []
  end
  
  # GET /metadata_sources
  # GET /metadata_sources.json
  def index
    @metadata_sources = MetadataSource.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @metadata_sources }
    end
  end

  # GET /metadata_sources/1
  # GET /metadata_sources/1.json
  def show
    @metadata_source = MetadataSource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @metadata_source }
    end
  end

  # GET /metadata_sources/1/edit
  def edit
    @metadata_source = MetadataSource.find(params[:id])
  end

  # PUT /metadata_sources/1
  # PUT /metadata_sources/1.json
  def update
    @metadata_source = MetadataSource.find(params[:id])

    respond_to do |format|
      if @metadata_source.update_attributes(params[:metadata_source])
        format.html { redirect_to @metadata_source, :notice => 'Metadata source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @metadata_source.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metadata_sources/1
  # DELETE /metadata_sources/1.json
  def destroy
    @metadata_source = MetadataSource.find(params[:id])
    @metadata_source.destroy

    respond_to do |format|
      format.html { redirect_to metadata_sources_url }
      format.json { head :no_content }
    end
  end
end
