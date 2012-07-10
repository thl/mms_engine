class MediaSourceAssociationsController < AclController
  helper :media
  before_filter :find_medium
  
  # GET /media_source_associations
  # GET /media_source_associations.xml
  def index
    @media_source_associations = @medium.media_source_associations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_source_associations }
    end
  end

  # GET /media_source_associations/1
  # GET /media_source_associations/1.xml
  def show
    @media_source_association = MediaSourceAssociation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_source_association }
    end
  end

  # GET /media_source_associations/new
  # GET /media_source_associations/new.xml
  def new
    @media_source_association = MediaSourceAssociation.new(:medium => @medium)
    @sources = Source.order('title')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_source_association }
    end
  end

  # GET /media_source_associations/1/edit
  def edit
    @media_source_association = MediaSourceAssociation.find(params[:id])
    @sources = Source.order('title')
  end

  # POST /media_source_associations
  # POST /media_source_associations.xml
  def create
    @media_source_association = MediaSourceAssociation.new(params[:media_source_association])
    respond_to do |format|
      if @media_source_association.save
        flash[:notice] = ts('new.successful', :what => MediaSourceAssociation.model_name.human.capitalize)
        format.html { redirect_to edit_medium_path(@medium) }
        format.xml  { render :xml => @media_source_association, :status => :created, :location => @media_source_association }
      else
        format.html do
          @sources = Source.order('title')
          render :action => 'new'
        end
        format.xml  { render :xml => @media_source_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_source_associations/1
  # PUT /media_source_associations/1.xml
  def update
    @media_source_association = MediaSourceAssociation.find(params[:id])

    respond_to do |format|
      if @media_source_association.update_attributes(params[:media_source_association])
        flash[:notice] = ts('edit.successful', :what => MediaSourceAssociation.model_name.human.capitalize)
        format.html { redirect_to edit_medium_path(@medium) }
        format.xml  { head :ok }
      else
        format.html do
          @sources = Source.order('title')
          render :action => 'edit'
        end
        format.xml  { render :xml => @media_source_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_source_associations/1
  # DELETE /media_source_associations/1.xml
  def destroy
    @media_source_association = MediaSourceAssociation.find(params[:id])
    @media_source_association.destroy

    respond_to do |format|
      format.html { redirect_to(media_source_associations_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_medium
    @medium = Medium.find(params[:medium_id])
  end  
end
