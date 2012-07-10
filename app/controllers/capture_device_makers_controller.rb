class CaptureDeviceMakersController < AclController
  # GET /capture_device_makers
  # GET /capture_device_makers.xml
  def index
    @capture_device_makers = CaptureDeviceMaker.order(title)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @capture_device_makers }
    end
  end

  # GET /capture_device_makers/1
  # GET /capture_device_makers/1.xml
  def show
    @capture_device_maker = CaptureDeviceMaker.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @capture_device_maker }
    end
  end

  # GET /capture_device_makers/new
  # GET /capture_device_makers/new.xml
  def new
    @capture_device_maker = CaptureDeviceMaker.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @capture_device_maker }
    end
  end

  # GET /capture_device_makers/1/edit
  def edit
    @capture_device_maker = CaptureDeviceMaker.find(params[:id])
  end

  # POST /capture_device_makers
  # POST /capture_device_makers.xml
  def create
    @capture_device_maker = CaptureDeviceMaker.new(params[:capture_device_maker])

    respond_to do |format|
      if @capture_device_maker.save
        flash[:notice] = ts('new.successful', :what => CaptureDeviceMaker.model_name.human.capitalize)
        format.html { redirect_to capture_device_makers_url }
        format.xml  { render :xml => @capture_device_maker, :status => :created, :location => @capture_device_maker }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @capture_device_maker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /capture_device_makers/1
  # PUT /capture_device_makers/1.xml
  def update
    @capture_device_maker = CaptureDeviceMaker.find(params[:id])

    respond_to do |format|
      if @capture_device_maker.update_attributes(params[:capture_device_maker])
        flash[:notice] = ts('edit.successful', :what => CaptureDeviceMaker.model_name.human.capitalize)
        format.html { redirect_to capture_device_makers_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @capture_device_maker.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /capture_device_makers/1
  # DELETE /capture_device_makers/1.xml
  def destroy
    @capture_device_maker = CaptureDeviceMaker.find(params[:id])
    @capture_device_maker.destroy
    respond_to do |format|
      format.html { redirect_to(capture_device_makers_url) }
      format.xml  { head :ok }
    end
  end
end