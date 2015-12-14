class CitationsController < AclController
 helper :media
  before_action :find_medium_and_reference
  # GET /citations
  # GET /citations.xml
  def index
    @citations = @reference.citations
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @citations }
    end
  end

  # GET /citations/1
  # GET /citations/1.xml
  def show
    @citation = Citation.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @citation }
    end
  end

  # GET /citations/new
  # GET /citations/new.xml
  def new
    #@citation = Citation.new
    @citation = @reference.citations.new
    @citation.creator = current_user.person
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @citation }
    end
  end

  # GET /citations/1/edit
  def edit
    @languages = ComplexScripts::Language.order('title')
    @citation = Citation.find(params[:id])
  end

  # POST /citations
  # POST /citations.xml
  def create
    @citation = @reference.citations.new(citation_params)
    @citation.creator = current_user.person
    respond_to do |format|
      if @citation.save
        flash[:notice] = 'Citation was successfully created.'
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
        format.xml  { render :xml => @citation, :status => :created, :location => @citation }
      else
        @languages = ComplexScripts::Language.order('title')
        format.html { render :action => "new" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /citations/1
  # PUT /citations/1.xml
  def update
    @citation = Citation.find(params[:id])
    respond_to do |format|
      if @citation.update_attributes(citation_params)
        flash[:notice] = 'Citation was successfully updated.'
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
        format.xml  { head :ok }
      else
        @languages = ComplexScripts::Language.order('title')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /citations/1
  # DELETE /citations/1.xml
  def destroy
    @citation = Citation.find(params[:id])
    @citation.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def citation_params
    params.require(:citation).permit(:medium_id, :page_number, :page_side, :line_number, :note)
  end
  
  def find_medium_and_reference
  	@reference_stack = []
    begin
      medium_id = params[:medium_id]
      @medium =  Medium.find(medium_id) if !medium_id.blank?
      if @medium
        medium = Medium.new
        medium.id = @medium.id
      end
      # this is in order to use polymorphic routes with the route for medium and not document, etc.
      @reference_stack << medium
      title_id = params[:title_id]
      @reference = Title.find(title_id) if !title_id.nil?
      @reference_stack << @reference
      translated_title_id = params[:translated_title_id]
      if !translated_title_id.nil?
        @reference = TranslatedTitle.find(translated_title_id)
        @reference_stack << @reference
      end
    rescue ActiveRecord::RecordNotFound
    end
    if @reference_stack.any?(&:nil?)
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end