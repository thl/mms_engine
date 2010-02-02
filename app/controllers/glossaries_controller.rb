class GlossariesController < AclController
  uses_tiny_mce :options => { 
  								:theme => 'advanced',
  								:editor_selector => 'mceEditor2',
  								:width => '550px',
  								:height => '220px',
  								:theme_advanced_resizing => 'true',
  								:theme_advanced_toolbar_location => 'top', 
  								:theme_advanced_toolbar_align => 'left',
  								:theme_advanced_buttons1 => %w{fullscreen separator bold italic underline strikethrough separator undo redo separator link unlink template formatselect code},
  								:theme_advanced_buttons2 => %w{cut copy paste separator pastetext pasteword separator bullist numlist outdent indent separator  justifyleft justifycenter justifyright justifiyfull separator removeformat  charmap },
  								:theme_advanced_buttons3 => [],
  								:plugins => %w{contextmenu paste media fullscreen template noneditable },				
  								:template_external_list_url => '/templates/templates.js',
  								:noneditable_leave_contenteditable => 'true',
  								:theme_advanced_blockformats => 'p,h1,h2,h3,h4,h5,h6'
  								}

  # GET /glossaries
  # GET /glossaries.xml

  def initialize
    @guest_perms = [ 'glossaries/show' ]
  end
  
  def index
    @glossaries = Glossary.find(:all)

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
    @glossary = Glossary.new
    @organizations = Organization.find(:all)
  end

  # GET /glossaries/1;edit
  def edit
    @glossary = Glossary.find(params[:id])
    @organizations = Organization.find(:all)
  end

  # POST /glossaries
  # POST /glossaries.xml
  def create
    @glossary = Glossary.new(params[:glossary])

    respond_to do |format|
      if @glossary.save
        flash[:notice] = ts('new.successful', :what => Glossary.human_name.capitalize)
        format.html { redirect_to glossaries_url }
        format.xml  { head :created, :location => glossary_url(@glossary) }
      else
        format.html do
          @organizations = Organization.find(:all)
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
        flash[:notice] = ts('edit.successful', :what => Glossary.human_name.capitalize)
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
