class MediaPublishersController < AclController 
  helper :media
  before_filter :find_medium
  caches_page :show, :if => Proc.new { |c| c.request.format.xml? }
  
  def initialize
    super
    @guest_perms = []
  end

  # GET /media_publishers
  # GET /media_publishers.xml
  def index
    @media_publisher = @medium.media_publisher.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_publisher }
    end
  end

  # GET /media_publishers/1
  # GET /media_publishers/1.xml
  def show
    @media_publisher = @medium.media_publisher
    @publishers = Publisher.find(:all)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_publisher }
    end
  end

  # GET /media_publishers/new
  # GET /media_publishers/new.xml
  def new
    @media_publisher = @medium.build_media_publisher
    @publishers = Publisher.order('title')

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_publisher.to_xml }
    end
  end

  # GET /media_publishers/1/edit
  def edit
    @publishers = Publisher.order('title')
    @media_publisher = @medium.media_publisher
    @media_publisher = @medium.create_media_publisher if @media_publisher.nil?
  end

  # POST /media_publishers
  # POST /media_publishers.xml
  def create
    @media_publisher = @medium.build_media_publisher(params[:media_publisher])
    respond_to do |format|
      if @media_publisher.save
        flash[:notice] = ts('new.successful', :what => MediaPublisher.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'media_publisher') }
        format.xml  { render :xml => @media_publisher, :status => :created, :location => medium_media_publisher_url(@medium, @media_publisher) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_publisher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_publishers/1
  # PUT /media_publishers/1.xml
  def update
    @media_publisher = @medium.media_publisher
    respond_to do |format|
      if @media_publisher.update_attributes(params[:media_publisher])
        flash[:notice] = ts('edit.successful', :what => MediaPublisher.model_name.human.capitalize)
        format.html { redirect_to edit_medium_path(@medium, :anchor => 'media_publisher') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_publisher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_publishers/1
  # DELETE /media_publishers/1.xml
  def destroy
    @media_publisher = @medium.media_publisher
    @media_publisher.destroy

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
