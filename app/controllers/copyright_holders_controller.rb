class CopyrightHoldersController < AclController
  # GET /copyright_holders
  # GET /copyright_holders.xml
  def index
    @copyright_holders = CopyrightHolder.order('title')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @copyright_holders.to_xml }
    end
  end

  # GET /copyright_holders/1
  # GET /copyright_holders/1.xml
  def show
    @copyright_holder = CopyrightHolder.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @copyright_holder.to_xml }
    end
  end

  # GET /copyright_holders/new
  def new
    @copyright_holder = CopyrightHolder.new
  end

  # GET /copyright_holders/1;edit
  def edit
    @copyright_holder = CopyrightHolder.find(params[:id])
  end

  # POST /copyright_holders
  # POST /copyright_holders.xml
  def create
    @copyright_holder = CopyrightHolder.new(params[:copyright_holder])

    respond_to do |format|
      if @copyright_holder.save
        flash[:notice] = ts('new.successful', :what => CopyrightHolder.model_name.human.capitalize)
        format.html { redirect_to copyright_holder_url(@copyright_holder) }
        format.xml  { head :created, :location => copyright_holder_url(@copyright_holder) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @copyright_holder.errors.to_xml }
      end
    end
  end

  # PUT /copyright_holders/1
  # PUT /copyright_holders/1.xml
  def update
    @copyright_holder = CopyrightHolder.find(params[:id])
    respond_to do |format|
      if @copyright_holder.update_attributes(params[:copyright_holder])
        flash[:notice] = ts('edit.successful', :what => CopyrightHolder.model_name.human.capitalize)
        format.html { redirect_to copyright_holder_url(@copyright_holder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @copyright_holder.errors.to_xml }
      end
    end
  end

  # DELETE /copyright_holders/1
  # DELETE /copyright_holders/1.xml
  def destroy
    @copyright_holder = CopyrightHolder.find(params[:id])
    @copyright_holder.destroy

    respond_to do |format|
      format.html { redirect_to copyright_holders_url }
      format.xml  { head :ok }
    end
  end
end