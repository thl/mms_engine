class KeywordsController < AclController
  cache_sweeper :keyword_sweeper, :only => [:create, :update, :destroy]
  
  # GET /keywords
  # GET /keywords.xml
  def index
    @keywords = Keyword.order('title')
      
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @keywords.to_xml }
    end
  end

  # GET /keywords/1
  # GET /keywords/1.xml
  def show
    @keyword = Keyword.find(params[:id])
    @medium = @keyword.media.first   
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @keyword.to_xml }
    end
  end

  # GET /keywords/new
  def new
     @keyword = Keyword.new
    end

  # GET /keywords/1;edit
  def edit
    @keyword = Keyword.find(params[:id])
  end

  # POST /keywords
  # POST /keywords.xml
  def create
    @keyword = Keyword.new(keyword_params)
    success = @keyword.save
      
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Keyword.model_name.human.capitalize)
        format.html { redirect_to keywords_url }
        format.xml  { head :created, :location => keyword_url(@keyword) }
      else
        format.html { render media_url }
        format.xml  { render :xml => @keyword.errors.to_xml }
      end
    end
  end

  # PUT /keywords/1
  # PUT /keywords/1.xml
  def update
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      if @keyword.update_attributes(keyword_params)
        flash[:notice] = ts('edit.successful', :what => Keyword.model_name.human.capitalize)
        format.html { redirect_to keywords_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @keyword.errors.to_xml }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.xml
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to keywords_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def keyword_params
    params.require(:keyword).permit(:title)
  end
end