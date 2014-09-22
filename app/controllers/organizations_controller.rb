class OrganizationsController < AclController
  # GET /organizations
  # GET /organizations.xml
  def index
    @organizations = Organization.order('title')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @organizations.to_xml }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    @organization = Organization.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @organization.to_xml }
    end
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1;edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        flash[:notice] = ts('new.successful', :what => Organization.model_name.human.capitalize)
        format.html { redirect_to organization_url(@organization) }
        format.xml  { head :created, :location => organization_url(@organization) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization.errors.to_xml }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    @organization = Organization.find(params[:id])

    respond_to do |format|
      if @organization.update_attributes(organization_params)
        flash[:notice] = ts('edit.successful', :what => Organization.model_name.human.capitalize)
        format.html { redirect_to organization_url(@organization) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization.errors.to_xml }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def organization_params
    params.require(:organization).permit(:title, :website)
  end
end