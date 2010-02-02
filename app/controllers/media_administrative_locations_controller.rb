class MediaAdministrativeLocationsController < AclController
  include HierarchicalMixedBrowse
  helper :media

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
  
  def initialize
    super
    @guest_perms += ['media_administrative_locations/expand_unit', 'media_administrative_locations/contract_unit']
    @element_name = 'administrative_unit_id'
    @controller_name = 'media_administrative_locations'
    @human_name = 'administrative unit'
    @model = AdministrativeUnit
    @association_model = MediaAdministrativeLocation
  end
  
  # To show browsing panel for admin units:
  # GET /media_administrative_locations
  # GET /media_administrative_locations.xml
  # 
  # To show all locations for a medium: 
  # GET /media_administrative_locations?medium_id=1
  # GET /media_administrative_locations.xml?medium_id=1
  # 
  # To show browsing panel defaulting to a specific unit expanded
  # on the left panel and its media on the right panel:
  # GET /media_administrative_locations?administrative_unit_id=1
  # GET /media_administrative_locations.xml?administrative_unit_id=1
  # 
  # To show specific medium on the left panel and
  # the media of a specific unit on the right panel:
  # GET /media_administrative_locations?medium_id=1&administrative_unit_id=2
  # GET /media_administrative_locations.xml?medium_id=1&administrative_unit_id=2
  def index
    super do |no_media|
      @countries = Country.find(:all, :order => '`title`') if @medium.nil?
      respond_to do |format|
        format.html do # index.rhtml
          if no_media
            if @medium.nil?
              render :template => 'media_administrative_locations/general_index'
            else
              render :template => 'main/hierarchy/mixed_associations/specific_index'
            end
          elsif @medium.nil?
            render :template => 'media_administrative_locations/general_index'
          else
            render :template => 'main/hierarchy/mixed_associations/general_index_for_medium'
          end
        end
        format.xml do
          associations = @association_model.find(:all)
          render :xml => associations.to_xml
        end
      end
    end
  end

  # GET /media_administrative_locations/1
  # GET /media_administrative_locations/1.xml
  def show
    super do
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @association.to_xml }
      end
    end
  end

  # GET /media_administrative_locations/new
  def new
    super do
      @elements = AdministrativeUnit.titles_with_ancestors
    end
  end

  # GET /media_administrative_locations/1;edit
  def edit
    super do
      @country = @element.administrative_level.country
      @elements = @country.administrative_units_with_ancestors
    end
  end

  # POST /media_administrative_locations
  # POST /media_administrative_locations.xml
  def create
    super do
      @elements = AdministrativeUnit.find(:all, :order => 'parent_id')
    end
  end

  # PUT /media_administrative_locations/1
  # PUT /media_administrative_locations/1.xml
  def update
    @association = MediaAdministrativeLocation.find(params[:id])
    @medium = @association.medium

    if @association.update_attributes(params[:association])
      notice = ts('edit.successful', :what => MediaAdministrativeLocation.human_name.capitalize)
      if request.xhr?
        render :text => "<p>#{notice}</p>"
      else
        respond_to do |format|
          flash[:notice] = notice
          format.html { redirect_to edit_medium_url(@medium) }
          format.xml  { head :ok }
        end
      end
    else
      if request.xhr?
        render :text => "<p>#{ts('edit.failure', :what => MediaAdministrativeLocation.human_name.capitalize)}</p>"
      else
        @medium = @association.medium
        @country = @element.administrative_level.country
        @elements = @country.administrative_units_with_ancestors
        @element = @association.element
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.xml  { render :xml => @association.errors.to_xml }
        end
      end
    end
  end

  # DELETE /media_administrative_locations/1
  # DELETE /media_administrative_locations/1.xml
  def destroy
    super
  end
  
  def expand_unit
    super
  end

  def contract_unit
    super
  end
  
  private
  
  def elements_url
    administrative_units_url(@country)
  end
  
  def association_url(association)
    media_administrative_location_url(association)
  end  
end