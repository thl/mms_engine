class CaptureDeviceModelsController < AclController
  before_action :find_capture_device_maker
  # GET /capture_device_models
  # GET /capture_device_models.xml
  def index
    @capture_device_models = @capture_device_maker.capture_device_models

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @capture_device_models }
    end
  end

  # GET /capture_device_models/1
  # GET /capture_device_models/1.xml
  def show
    @capture_device_model = CaptureDeviceModel.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @capture_device_model }
    end
  end

  # GET /capture_device_models/new
  # GET /capture_device_models/new.xml
  def new
    @capture_device_model = CaptureDeviceModel.new(:capture_device_maker => @capture_device_maker)
    @capture_device_makers = CaptureDeviceMaker.order('title')
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @capture_device_model }
    end
  end

  # GET /capture_device_models/1/edit
  def edit
    @capture_device_model = CaptureDeviceModel.find(params[:id])
    @capture_device_makers = CaptureDeviceMaker.order('title')
  end

  # POST /capture_device_models
  # POST /capture_device_models.xml
  def create
    @capture_device_model = CaptureDeviceModel.new(capture_device_model_params)

    respond_to do |format|
      if @capture_device_model.save
        flash[:notice] = ts('new.successful', :what => CaptureDeviceModel.model_name.human.capitalize)
        format.html { redirect_to capture_device_makers_url }
        format.xml  { render :xml => @capture_device_model, :status => :created, :location => @capture_device_model }
      else
        @capture_device_makers = CaptureDeviceMaker.order('title')
        format.html { render :action => "new" }
        format.xml  { render :xml => @capture_device_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /capture_device_models/1
  # PUT /capture_device_models/1.xml
  def update
    @capture_device_model = CaptureDeviceModel.find(params[:id])
    respond_to do |format|
      if @capture_device_model.update_attributes(capture_device_model_params)
        flash[:notice] = ts('edit.successful', :what => CaptureDeviceModel.model_name.human.capitalize)
        format.html { redirect_to capture_device_makers_url }
        format.xml  { head :ok }
      else
        @capture_device_makers = CaptureDeviceMaker.order('title')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @capture_device_model.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /capture_device_models/1
  # DELETE /capture_device_models/1.xml
  def destroy
    @capture_device_model = CaptureDeviceModel.find(params[:id])
    @capture_device_model.destroy

    respond_to do |format|
      format.html { redirect_to(capture_device_makers_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_capture_device_maker
    @capture_device_maker = CaptureDeviceMaker.find(params[:capture_device_maker_id])
  end
  
  def capture_device_model_params
    params.require(:capture_device_model).permit(:capture_device_maker_id, :title, :exif_tag)
  end
end