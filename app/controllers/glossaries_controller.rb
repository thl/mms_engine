class GlossariesController < AclController

  # GET /glossaries
  # GET /glossaries.xml

  def initialize
    @guest_perms = [ 'glossaries/show' ]
  end
  
  def index
    @glossaries = Glossary.order('title')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @glossaries.to_xml }
    end
  end

  # GET /glossaries/1
  # GET /glossaries/1.xml
  def show
    @glossary = Glossary.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @glossary.to_xml }
    end
  end

  # GET /glossaries/new
  def new
    @glossary = Glossary.order('title')
    @organizations = Organization.order('title')
  end

  # GET /glossaries/1;edit
  def edit
    @glossary = Glossary.find(params[:id])
    @organizations = Organization.order('title')
  end

  # POST /glossaries
  # POST /glossaries.xml
  def create
    @glossary = Glossary.new(params[:glossary])

    respond_to do |format|
      if @glossary.save
        flash[:notice] = ts('new.successful', :what => Glossary.model_name.human.capitalize)
        format.html { redirect_to glossaries_url }
        format.xml  { head :created, :location => glossary_url(@glossary) }
      else
        format.html do
          @organizations = Organization.order('title')
          render :action => 'new'
        end
        format.xml  { render :xml => @glossary.errors.to_xml }
      end
    end
  end

  # PUT /glossaries/1
  # PUT /glossaries/1.xml
  def update
    @glossary = Glossary.find(params[:id])

    respond_to do |format|
      if @glossary.update_attributes(params[:glossary])
        flash[:notice] = ts('edit.successful', :what => Glossary.model_name.human.capitalize)
        format.html { redirect_to glossaries_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @glossary.errors.to_xml }
      end
    end
  end

  # DELETE /glossaries/1
  # DELETE /glossaries/1.xml
  def destroy
    @glossary = Glossary.find(params[:id])
    @glossary.destroy

    respond_to do |format|
      format.html { redirect_to glossaries_url }
      format.xml  { head :ok }
    end
  end
end