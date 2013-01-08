class MediaKeywordAssociationsController < AclController
  # GET /media_keyword_associations
  # GET /media_keyword_associations.xml
  def index
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to countries_path
    else
      @media_keyword_associations = @medium.media_keyword_associations
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @media_keyword_associations.to_xml }
      end
    end
  end

  # GET /media_keyword_associations/1
  # GET /media_keyword_associations/1.xml
  def show
    @media_keyword_association = MediaKeywordAssociation.find(params[:id])
    @medium = @media_keyword_association.medium
    @keyword = @media_keyword_association.keyword

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @media_keyword_association.to_xml }
    end
  end

  # GET /media_keyword_associations/new
  def new
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to countries_path
    else
      @keywords = Keyword.find(:all, :order => 'title')
      @media_keyword_association = MediaKeywordAssociation.new(:medium_id => @medium.id)
    end
  end

  # GET /media_keyword_associations/1;edit
  def edit
    @media_keyword_association = MediaKeywordAssociation.find(params[:id])
    @medium = @media_keyword_association.medium
    @keywords = Keyword.find(:all, :order => 'title')
  end

  # POST /media_keyword_associations
  # POST /media_keyword_associations.xml
  def create
    @media_keyword_association = MediaKeywordAssociation.new(params[:media_keyword_association])
    @medium = @media_keyword_association.medium

    respond_to do |format|
      if @media_keyword_association.save
        flash[:notice] = ts('new.successful', :what => MediaKeywordAssociation.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => media_keyword_association_url(@media_keyword_association) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_keyword_association.errors.to_xml }
      end
    end
  end

  # PUT /media_keyword_associations/1
  # PUT /media_keyword_associations/1.xml
  def update
    @media_keyword_association = MediaKeywordAssociation.find(params[:id])
    @medium = @media_keyword_association.medium
    respond_to do |format|
      if @media_keyword_association.update_attributes(params[:media_keyword_association])
        flash[:notice] = ts('edit.successful', :what => MediaKeywordAssociation.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_keyword_association.errors.to_xml }
      end
    end
  end

  # DELETE /media_keyword_associations/1
  # DELETE /media_keyword_associations/1.xml
  def destroy
    @media_keyword_association = MediaKeywordAssociation.find(params[:id])
    @medium = @media_keyword_association.medium
    @media_keyword_association.destroy

    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
end
