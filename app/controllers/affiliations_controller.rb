class AffiliationsController < AclController
  helper :media
  before_filter :find_medium
  
  # GET /affiliations
  # GET /affiliations.xml
  def index
    if !@medium.nil?
      @projects = Project.find(:all)
      @sponsors = Sponsor.find(:all)
      @organizations = Organization.find(:all)
      @affiliations= @medium.affiliations
      
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @affiliations.to_xml }
      end
    end
  end

  # GET /affiliations/1
  # GET /affiliations/1.xml
  def show
    @affiliation = Affiliation.find(params[:id])
    @medium = @affiliation.medium if @medium.nil?
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @caption.to_xml }
    end
  end

  # GET /affiliations/new
  def new
    if !@medium.nil?
      @affiliation = @medium.affiliations.build
      @sponsors = Sponsor.find(:all)
      @organizations = Organization.find(:all)
      @projects = Project.find(:all)
    end
  end

  # GET /affiliations/1;edit
  def edit
    @affiliation = Affiliation.find(params[:id])
    @medium = @affiliation.medium if @medium.nil?
    @sponsors = Sponsor.find(:all)
    @organizations = Organization.find(:all)
    @projects = Project.find(:all)
  end

  # POST /affiliations
  # POST /affiliations.xml
  def create
    @affiliation = Affiliation.new(params[:affiliation])
    success = @affiliation.save
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Affiliation.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@affiliation.medium) }
        format.xml  { head :created, :location => medium_affiliation_url(@medium, @affiliation) }
      else
        @medium = @affiliation.medium if @medium.nil?
        @sponsors = Sponsor.find(:all)
        @organizations = Organization.find(:all)
        @projects = Project.find(:all)
        format.html { render :action => 'new' }
        format.xml  { render :xml => @affiliation.errors.to_xml }
      end
    end
  end

  # PUT /affiliations/1
  # PUT /affiliations/1.xml
  def update
    @affiliation = Affiliation.find(params[:id])
    @medium = @affiliation.medium if @medium.nil?
    respond_to do |format|
      if @affiliation.update_attributes(params[:affiliation])
        flash[:notice] = ts('edit.successful', :what => Affiliation.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      else
        @sponsors = Sponsor.find(:all)
        @organizations = Organization.find(:all)
        @projects = Project.find(:all)        
        format.html { render :action => "edit" }
        format.xml  { render :xml => @affiliation.errors.to_xml }
      end
    end
  end

  # DELETE /affiliations/1
  # DELETE /affiliations/1.xml
  def destroy
    @affiliation = Affiliation.find(params[:id])
    @medium = @affiliation.medium if @medium.nil?
    @affiliation.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_medium
    begin
      medium_id = params[:medium_id]
      @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    rescue ActiveRecord::RecordNotFound
      @medium = nil
    end
    if @medium.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end