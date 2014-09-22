class StatusesController < AclController
   
  # GET /statuses
  # GET /statuses.xml
  def index
    @statuses = Status.order('position')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statuses }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.xml
  def show
    @status = Status.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.xml
  def new
    @status = Status.new(:position => Status.maximum(:position)+1)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.xml
  def create
      @status = Status.new(status_params)
      respond_to do |format|
        if @status.save
          flash[:notice] = ts('new.successful', :what => Status.model_name.human.capitalize)
          format.html { redirect_to statuses_url }
          format.xml  { render :xml => @status, :status => :created, :location => @status }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        end
      end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
  def update
      @status = Status.find(params[:id])
      respond_to do |format|
        if @status.update_attributes(status_params)
          flash[:notice] = ts('edit.successful', :what => Status.model_name.human.capitalize)
          format.html { redirect_to statuses_url }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        end
      end
  end  

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
      @status = Status.find(params[:id])
      @status.destroy
      respond_to do |format|
        format.html { redirect_to statuses_url }
        format.xml  { head :ok }
      end
  end
  
  private
  
  def status_params
    params.require(:status).permit(:title, :description, :position)
  end
end