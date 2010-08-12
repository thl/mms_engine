class MediaPublishersController < AclController 
  # GET /media_publishers
  # GET /media_publishers.xml
  def index
    @media_publishers = MediaPublisher.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_publishers }
    end
  end

  # GET /media_publishers/1
  # GET /media_publishers/1.xml
  def show
    @media_publisher = MediaPublisher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @media_publisher }
    end
  end

  # GET /media_publishers/new
  # GET /media_publishers/new.xml
  def new
    @media_publisher = MediaPublisher.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_publisher }
    end
  end

  # GET /media_publishers/1/edit
  def edit
    @media_publisher = MediaPublisher.find(params[:id])
  end

  # POST /media_publishers
  # POST /media_publishers.xml
  def create
    @media_publisher = MediaPublisher.new(params[:media_publisher])

    respond_to do |format|
      if @media_publisher.save
        flash[:notice] = 'MediaPublisher was successfully created.'
        format.html { redirect_to(@media_publisher) }
        format.xml  { render :xml => @media_publisher, :status => :created, :location => @media_publisher }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_publisher.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_publishers/1
  # PUT /media_publishers/1.xml
  def update
    @media_publisher = MediaPublisher.find(params[:id])

    respond_to do |format|
      if @media_publisher.update_attributes(params[:media_publisher])
        flash[:notice] = 'MediaPublisher was successfully updated.'
        format.html { redirect_to(@media_publisher) }
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
    @media_publisher = MediaPublisher.find(params[:id])
    @media_publisher.destroy

    respond_to do |format|
      format.html { redirect_to(media_publishers_url) }
      format.xml  { head :ok }
    end
  end
end
