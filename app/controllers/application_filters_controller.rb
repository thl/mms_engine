class ApplicationFiltersController < AclController
  # GET /filters
  # GET /filters.xml
  def index
    @filters = ApplicationFilter.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @filters }
    end
  end

  # GET /filters/1
  # GET /filters/1.xml
  def show
    @filter = ApplicationFilter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @filter }
    end
  end

  # GET /filters/new
  # GET /filters/new.xml
  def new
    @filter = ApplicationFilter.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filter }
    end
  end

  # GET /filters/1/edit
  def edit
    @filter = ApplicationFilter.find(params[:id])
  end

  # POST /filters
  # POST /filters.xml
  def create
    @filter = ApplicationFilter.new(filter_params)

    respond_to do |format|
      if @filter.save
        flash[:notice] = 'Filter was successfully created.'
        format.html { redirect_to(@filter) }
        format.xml  { render :xml => @filter, :status => :created, :location => @filter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filters/1
  # PUT /filters/1.xml
  def update
    @filter = ApplicationFilter.find(params[:id])

    respond_to do |format|
      if @filter.update_attributes(filter_params)
        flash[:notice] = 'Filter was successfully updated.'
        format.html { redirect_to(@filter) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.xml
  def destroy
    @filter = ApplicationFilter.find(params[:id])
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to(filters_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def filter_params
    params.require(:filter).permit(:title)
  end
end
