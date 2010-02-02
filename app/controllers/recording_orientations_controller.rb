class RecordingOrientationsController < AclController
  # GET /recording_orientations
  # GET /recording_orientations.xml
  def index
    @recording_orientations = RecordingOrientation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @recording_orientations }
    end
  end

  # GET /recording_orientations/1
  # GET /recording_orientations/1.xml
  def show
    @recording_orientation = RecordingOrientation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @recording_orientation }
    end
  end

  # GET /recording_orientations/new
  # GET /recording_orientations/new.xml
  def new
    @recording_orientation = RecordingOrientation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @recording_orientation }
    end
  end

  # GET /recording_orientations/1/edit
  def edit
    @recording_orientation = RecordingOrientation.find(params[:id])
  end

  # POST /recording_orientations
  # POST /recording_orientations.xml
  def create
    @recording_orientation = RecordingOrientation.new(params[:recording_orientation])

    respond_to do |format|
      if @recording_orientation.save
        flash[:notice] = ts('new.successful', :what => RecordingOrientation.human_name.capitalize)
        format.html { redirect_to recording_orientations_url }
        format.xml  { render :xml => @recording_orientation, :status => :created, :location => @recording_orientation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recording_orientation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recording_orientations/1
  # PUT /recording_orientations/1.xml
  def update
    @recording_orientation = RecordingOrientation.find(params[:id])

    respond_to do |format|
      if @recording_orientation.update_attributes(params[:recording_orientation])
        flash[:notice] = ts('edit.successful', :what => RecordingOrientation.human_name.capitalize)
        format.html { redirect_to recording_orientations_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recording_orientation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recording_orientations/1
  # DELETE /recording_orientations/1.xml
  def destroy
    @recording_orientation = RecordingOrientation.find(params[:id])
    @recording_orientation.destroy

    respond_to do |format|
      format.html { redirect_to(recording_orientations_url) }
      format.xml  { head :ok }
    end
  end
end
