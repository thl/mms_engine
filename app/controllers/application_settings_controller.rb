class ApplicationSettingsController < AclController
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

  # GET /application_settings
  # GET /application_settings.xml
  def index
    @application_settings = ApplicationSetting.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @application_settings.to_xml }
    end
  end

  # GET /application_settings/1
  # GET /application_settings/1.xml
  def show
    @application_setting = ApplicationSetting.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @application_setting.to_xml }
    end
  end

  # GET /application_settings/new
  def new
    @application_setting = ApplicationSetting.new
  end

  # GET /application_settings/1;edit
  def edit
    @application_setting = ApplicationSetting.find(params[:id])
  end

  # POST /application_settings
  # POST /application_settings.xml
  def create
    @application_setting = ApplicationSetting.new(params[:application_setting])

    respond_to do |format|
      if @application_setting.save
        flash[:notice] = ts('new.successful', :what => ApplicationSetting.human_name.capitalize)
        format.html { redirect_to application_settings_url }
        format.xml  { head :created, :location => application_setting_url(@application_setting) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @application_setting.errors.to_xml }
      end
    end
  end

  # PUT /application_settings/1
  # PUT /application_settings/1.xml
  def update
    @application_setting = ApplicationSetting.find(params[:id])
    respond_to do |format|
      if @application_setting.update_attributes(params[:application_setting])
        flash[:notice] = ts('edit.successful', :what => ApplicationSetting.human_name.capitalize)
        format.html { redirect_to application_settings_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @application_setting.errors.to_xml }
      end
    end
  end

  # DELETE /application_settings/1
  # DELETE /application_settings/1.xml
  def destroy
    @application_setting = ApplicationSetting.find(params[:id])
    @application_setting.destroy

    respond_to do |format|
      format.html { redirect_to application_settings_url }
      format.xml  { head :ok }
    end
  end
end
