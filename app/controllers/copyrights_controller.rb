class CopyrightsController < AclController
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

  # GET /copyrights
  # GET /copyrights.xml
  def index
      begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to media_path
    else
      @copyright_holders = CopyrightHolder.find(:all)
      @reproduction_types = ReproductionType.find(:all, :order => '`order`')
      @copyrights = @medium.copyrights
      
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @captions.to_xml }
      end
    end
  end

  # GET /copyrights/1
  # GET /copyrights/1.xml
  def show
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
    @copyright_holder = @copyright.copyright_holder
    @reproduction_type = @copyright.reproduction_type
    
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @caption.to_xml }
    end
  end

  # GET /copyrights/new
  def new
    begin
      @medium = Medium.find(params[:medium_id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid medium #{params[:medium_id]}")
      redirect_to media_path
    else
      @copyright_holders = CopyrightHolder.find(:all)
      @reproduction_types = ReproductionType.find(:all, :order => '`order`')
      @copyright = Copyright.new(:medium => @medium)
    end
  end

  # GET /copyrights/1;edit
  def edit
    @copyright_holders = CopyrightHolder.find(:all)
    @reproduction_types = ReproductionType.find(:all, :order => '`order`')
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
  end

  # POST /copyrights
  # POST /copyrights.xml
  def create
    @copyright = Copyright.new(params[:copyright])
    @medium = @copyright.medium

    respond_to do |format|
      if @copyright.save
        flash[:notice] = ts('new.successful', :what => Copyright.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => copyright_url(@copyright) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @copyright.errors.to_xml }
      end
    end
  end

  # PUT /copyrights/1
  # PUT /copyrights/1.xml
  def update
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium

    respond_to do |format|
      if @copyright.update_attributes(params[:copyright])
        flash[:notice] = ts('edit.successful', :what => Copyright.human_name.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @copyright.errors.to_xml }
      end
    end
  end

  # DELETE /copyrights/1
  # DELETE /copyrights/1.xml
  def destroy
    @copyright = Copyright.find(params[:id])
    @medium = @copyright.medium
    @copyright.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
    end
  end
end
