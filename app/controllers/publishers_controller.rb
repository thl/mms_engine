class PublishersController < AclController 
  # GET /publishers
  # GET /publishers.xml
  def index
    @publishers = Publisher.order('title')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @publishers.to_xml }
    end
  end

  # GET /publishers/1
  # GET /publishers/1.xml
  def show
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @publisher.to_xml }
    end
  end

  # GET /publishers/new
  # GET /publishers/new.xml
  def new
    @publisher = Publisher.new
    @countries = Country.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @publisher.to_xml }
    end
  end

  # GET /publishers/1/edit
  def edit
    @publisher = Publisher.find(params[:id])
    @countries = Country.find(:all)
  end

  # POST /publishers
  # POST /publishers.xml
  def create
    @publisher = Publisher.new(params[:publisher])

    respond_to do |format|
      if @publisher.save
        flash[:notice] = ts('new.successful', :what => Publisher.model_name.human.capitalize)
        format.html { redirect_to publishers_url }
	format.xml  { head :created, :location => glossary_url(@publisher) }
      else
	format.html do
          @countries = Country.find(:all)
          render :action => 'new'
        end
        format.xml  { render :xml => @publisher.errors.to_xml }
      end
    end
  end

  # PUT /publishers/1
  # PUT /publishers/1.xml
  def update
    @publisher = Publisher.find(params[:id])

    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        flash[:notice] = ts('edit.successful', :what => Publisher.model_name.human.capitalize)
        format.html { redirect_to publishers_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publisher.errors.to_xml }
      end
    end
  end

  # DELETE /publishers/1
  # DELETE /publishers/1.xml
  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy

    respond_to do |format|
      format.html { redirect_to publishers_url }
      format.xml  { head :ok }
    end
  end
end