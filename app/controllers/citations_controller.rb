class CitationsController < AclController
 helper :media
  before_filter :find_medium_and_reference
  # GET /citations
  # GET /citations.xml
  def index
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @citations = @reference.citations.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @citations }
      end
    end
  end

  # GET /citations/1
  # GET /citations/1.xml
  def show
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @citation = Citation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @citation }
      end
    end
  end

  # GET /citations/new
  # GET /citations/new.xml
  def new
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    #@citation = Citation.new
      @languages = ComplexScripts::Language.find(:all, :order => 'title')
      language = ComplexScripts::Language.find_iso_code(I18n.locale)
      @citation = @reference.citations.new(:language => language, :creator => current_user.person)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @citation }
      end
    end
  end

  # GET /citations/1/edit
  def edit
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @languages = ComplexScripts::Language.find(:all, :order => 'title')
    @citation = Citation.find(params[:id])
    end
  end

  # POST /citations
  # POST /citations.xml
  def create
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @citation = @reference.citations.new(params[:citation])

    respond_to do |format|
      if @citation.save
        flash[:notice] = 'Citation was successfully created.'
        format.html { redirect_to @reference.class == Title ? medium_title_citation_url(@medium, @reference, @citation) : medium_title_translated_title_citation_url(@medium, @title, @reference, @citation)}
        format.xml  { render :xml => @citation, :status => :created, :location => @citation }
      else
        @languages = ComplexScripts::Language.find(:all, :order => 'title')
        format.html { render :action => "new" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /citations/1
  # PUT /citations/1.xml
  def update
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @citation = Citation.find(params[:id])

    respond_to do |format|
      if @citation.update_attributes(params[:citation])
        flash[:notice] = 'Citation was successfully updated.'
        format.html { redirect_to @reference.class == Title ? medium_title_citations_url(@medium, @reference, @citation) : medium_title_translated_title_citations_url(@medium, @title, @reference, @citation) }
        format.xml  { head :ok }
      else
        @languages = ComplexScripts::Language.find(:all, :order => 'title')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @citation.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /citations/1
  # DELETE /citations/1.xml
  def destroy
   if !@medium.nil? && !@title.nil? && !@reference.nil?
    @citation = Citation.find(params[:id])
    @citation.destroy

    respond_to do |format|
      format.html { redirect_to @reference.class == Title ? medium_title_citations_url(@medium, @reference) : medium_title_translated_title_citation_url(@medium, @title, @reference)}
      format.xml  { head :ok }
    end
  end
end

private
  
  def find_medium_and_reference
  	@medium, @title, @reference = nil
    begin
      medium_id = params[:medium_id]
      @medium =  Medium.find(medium_id) if !medium_id.blank?
      title_id = params[:title_id]
      @title = Title.find(title_id) if !title_id.nil?
      translated_title_id = params[:translated_title_id]
      @reference = translated_title_id.nil? ? @title : TranslatedTitle.find(translated_title_id)
    rescue ActiveRecord::RecordNotFound
    end
    if @medium.nil? ||  @title.nil? || @reference.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end
