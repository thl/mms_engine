class SponsorsController < AclController
  # GET /sponsors
  # GET /sponsors.xml
  def index
    @sponsors = Sponsor.order('title')
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @sponsors.to_xml }
    end
  end

  # GET /sponsors/1
  # GET /sponsors/1.xml
  def show
    @sponsor = Sponsor.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @sponsor.to_xml }
    end
  end

  # GET /sponsors/new
  def new
    @sponsor = Sponsor.new
  end

  # GET /sponsors/1;edit
  def edit
    @sponsor = Sponsor.find(params[:id])
  end

  # POST /sponsors
  # POST /sponsors.xml
  def create
    @sponsor = Sponsor.new(params[:sponsor])
    respond_to do |format|
      if @sponsor.save
        flash[:notice] = ts('new.successful', :what => Sponsor.model_name.human.capitalize)
        format.html { redirect_to sponsor_url(@sponsor) }
        format.xml  { head :created, :location => sponsor_url(@sponsor) }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @sponsor.errors.to_xml }
      end
    end
  end

  # PUT /sponsors/1
  # PUT /sponsors/1.xml
  def update
    @sponsor = Sponsor.find(params[:id])
    respond_to do |format|
      if @sponsor.update_attributes(params[:sponsor])
        flash[:notice] = ts('edit.successful', :what => Sponsor.model_name.human.capitalize)
        format.html { redirect_to sponsor_url(@sponsor) }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @sponsor.errors.to_xml }
      end
    end
  end

  # DELETE /sponsors/1
  # DELETE /sponsors/1.xml
  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    respond_to do |format|
      format.html { redirect_to sponsors_url }
      format.xml  { head :ok }
    end
  end
end