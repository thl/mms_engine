class AdministrativeUnitsController < AclController
  include HierarchicalAdmin
  before_filter :find_country

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
    @guest_perms += ['administrative_units/expand', 'administrative_units/contract']
    @controller_name = 'administrative_units'
    @model = AdministrativeUnit    
    @human_name = 'administrative unit'
  end

  # GET /administrative_units?administrative_level_id=1[&parent_administrative_unit_id=2]
  # GET /administrative_units?administrative_level_id=1[&parent_administrative_unit_id=2].xml
  def index
    if @country.nil?
      redirect_to countries_path
    else
      @administrative_level = @country.administrative_levels.first
      @elements = @administrative_level.administrative_units.find(:all, :order => 'title')
      respond_to do |format|
        format.html # index.rhtml
        format.xml  do
          @dtd = "#{@country.title.downcase}_#{@controller_name}"
          render :action => 'index', :layout => 'application'
        end
      end
    end
  end

  # GET /administrative_units/1
  # GET /administrative_units/1.xml
  def show
    @element = AdministrativeUnit.find(params[:id])
    @country = @element.administrative_level.country if @country.nil?
    if request.xhr?
      administrative_level = @country.administrative_levels.first
      @elements = administrative_level.administrative_units.find(:all, :order => 'title')
      @margin_depth = @element.ancestors.size
      @current = @element.ancestors.collect{|c| c.id}
      @current << @element.id
      render :update do |page|
        page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        page.replace_html 'secondary', :partial => 'main/hierarchy/admin/show'
      end
    else
      respond_to do |format|
        format.html { render :template => 'main/hierarchy/admin/show' }
        format.xml  do
          @dtd = "#{@country.title.downcase}_#{@controller_name.singularize}"
          render :action => 'show', :layout => 'application'
        end
      end      
    end
  end

  # GET /administrative_units/new?administrative_level_id=1[&parent_administrative_unit_id=2]
  def new
    super do
      begin
        administrative_level_id = params[:administrative_level_id]
        @administrative_level = administrative_level_id.blank? ? @parent.administrative_level.next_level : AdministrativeLevel.find(administrative_level_id)
      rescue ActiveRecord::RecordNotFound
        logger.error("Attempt to access invalid administrative level or administrative unit")
        redirect_to countries_path
      else
        if @administrative_level.nil?
          logger.error("Cannot create an administrative unit without an administrative level!")
          redirect_to countries_path
        else
          @country = @administrative_level.country if @country.nil?
          @element.administrative_level = @administrative_level
          render :partial => 'new' if request.xhr?
        end
      end
    end
  end

  # GET /administrative_units/1;edit
  def edit
    @element = AdministrativeUnit.find(params[:id])
    administrative_level = @element.administrative_level
    @country = administrative_level.country if @country.nil?
    @administrative_levels = @country.administrative_levels
    upper_level = @administrative_levels.find(:first, :conditions => {:level => administrative_level.level-1})
    @administrative_units = upper_level.nil? ? nil : upper_level.administrative_units_with_ancestors
    render :partial => 'edit' if request.xhr?
  end

  # POST /administrative_units
  # POST /administrative_units.xml
  def create
    @element = @model.new(params[:element])    
    @country = @element.administrative_level.country if @country.nil?
    administrative_levels = @country.administrative_levels.find(:all, :order => 'level')
    first_level = administrative_levels.first
    second_level = administrative_levels[1]
    adopt_children = @element.administrative_level==first_level && first_level.administrative_units.empty? && !second_level.nil? && !second_level.administrative_units.empty?
    if @element.save
      flash[:notice] = ts('new.successful', :what => AdministrativeUnit.human_name.capitalize)
      if request.xhr?
        AdministrativeUnit.update_all("parent_id = #{@element.id}", {:administrative_level_id => second_level.id}) if adopt_children
        @child = @element.parent
        @current = [@element.id]
        @elements = first_level.administrative_units.find(:all, :order => 'title')
        render :update do |page|
          page.replace_html 'secondary', :partial => 'main/hierarchy/admin/show'
          if @child.nil?
            page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
          else
            @margin_depth = @child.ancestors.size
            page.replace_html "#{@child.id}_div", :partial => 'main/hierarchy/admin/expanded'
          end
        end
      else
        respond_to do |format|
          format.html { redirect_to @element.parent.nil? ? elements_url : element_url(@element.parent) }
          format.xml  { head :created, :location => element_url(@element) }
        end
      end
    else
      if request.xhr?
        render(:update) {|page| page.replace_html 'secondary', :partial => 'new'}
      else      
        respond_to do |format|
          format.html { render :action => 'new' }
          format.xml  { render :xml => @element.errors.to_xml }
        end
      end
    end
  end
  
  # PUT /administrative_units/1
  # PUT /administrative_units/1.xml
  def update
    @element = @model.find(params[:id])
    parent = @element.parent
    if @element.update_attributes(params[:element])
      flash[:notice] = ts('edit.successful', :what => AdministrativeUnit.human_name.capitalize)
      if request.xhr?
        @country = @element.administrative_level.country if @country.nil?
        administrative_level = @country.administrative_levels.first
        @elements = administrative_level.administrative_units.find(:all, :order => 'title')
        render(:update) do |page|
          page.replace_html 'secondary', :partial => 'main/hierarchy/admin/show'
          @element.reload
          @current = @element.ancestors.collect{|c| c.id}
          @current << @element.id
          page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        end
      else
        respond_to do |format|
          format.html { redirect_to element_url(@element) }
          format.xml  { head :ok }
        end
      end
    else
      @country = @element.administrative_level.country if @country.nil?
      administrative_level = @country.administrative_levels.first
      @elements = administrative_level.administrative_units.find(:all, :order => 'title')
      if request.xhr?
        render :partial => 'edit'
      else
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.xml  { render :xml => @element.errors.to_xml }
        end
      end      
    end    
  end

  # DELETE /administrative_units/1
  # DELETE /administrative_units/1.xml
  def destroy
    @element = @model.find(params[:id])
    title = @element.title
    @child = @element.parent
    @country = @element.administrative_level.country if @country.nil?    
    MediaAdministrativeLocation.update_all("administrative_unit_id = #{@child.id}", {:administrative_unit_id => @element.id}) if !@child.nil?
    @element.destroy
    administrative_level = @country.administrative_levels.first
    @elements = administrative_level.administrative_units.find(:all, :order => 'title')
    if request.xhr?
      render :update do |page|
        page.replace_html 'secondary', ts('delete.successful', :what => AdministrativeUnit.human_name.capitalize)
        if @child.nil?
          page.replace_html 'navigation', :partial => 'main/hierarchy/admin/index'
        else
          @margin_depth = @child.ancestors.size
          page.replace_html "#{@child.id}_div", :partial => 'main/hierarchy/admin/expanded'
        end
      end          
    else
      respond_to do |format|
        format.html { redirect_to elements_url }
        format.xml  { head :ok }
      end
    end
  end
    
  private
    
  def elements_url
    administrative_units_url(@country)
  end
  
  def element_url(id)
    administrative_unit_url(@country, id)
  end
  
  def find_country
    country_id = params[:country_id]
    if country_id.nil?
      @country = nil
    else
      begin
        @country = Country.find(country_id)
      rescue ActiveRecord::RecordNotFound
        @country = nil
      end
    end    
  end
end