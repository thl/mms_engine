class AdministrativeLevelsController < AclController
  before_filter :find_country
  
  # GET /administrative_levels?country_id=1
  # GET /administrative_levels.xml?country_id=1
  def index
    if @country.nil?
      redirect_to countries_path
    else    
      @administrative_levels = @country.administrative_levels
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @administrative_levels.to_xml }
      end
    end
  end

  # GET /administrative_levels/1
  # GET /administrative_levels/1.xml
  def show
    @administrative_level = AdministrativeLevel.find(params[:id])
    @country = @administrative_level.country if @country.nil?

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @administrative_level.to_xml }
    end
  end

  # GET /administrative_levels/new?country_id=1
  def new
    if @country.nil?
      redirect_to countries_path
    else
      level = AdministrativeLevel.maximum(:level, :conditions => {:country_id => @country})
      if level.nil?
        highest_level = 1
      else
        highest_level =  level + 1
      end
      @administrative_level = AdministrativeLevel.new(:country => @country, :level => highest_level)
    end
  end

  # GET /administrative_levels/1;edit
  def edit
    @administrative_level = AdministrativeLevel.find(params[:id])
    @country = @administrative_level.country if @country.nil?
    @level = @administrative_level.level
  end

  # POST /administrative_levels
  # POST /administrative_levels.xml
  def create
    @administrative_level = AdministrativeLevel.new(params[:administrative_level])
    level = AdministrativeLevel.maximum(:level, :conditions => {:country_id => @country})
    AdministrativeLevel.update_all('level = level + 1', ['country_id = ? AND level >= ?', @country.id, @administrative_level.level]) if !level.nil? && @administrative_level.level <= level
    respond_to do |format|
      if @administrative_level.save
        flash[:notice] = ts('new.successful', :what => AdministrativeLevel.human_name.capitalize)
        format.html { redirect_to country_administrative_levels_url(@administrative_level.country) }
        format.xml  { head :created, :location => country_administrative_level_url(@country, @administrative_level) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @administrative_level.errors.to_xml }
      end
    end
  end

  # PUT /administrative_levels/1
  # PUT /administrative_levels/1.xml
  def update
    @administrative_level = AdministrativeLevel.find(params[:id])

    respond_to do |format|
      if @administrative_level.update_attributes(params[:administrative_level])
        flash[:notice] = ts('edit.successful', :what => AdministrativeLevel.human_name.capitalize)
        format.html { redirect_to country_administrative_levels_url(@administrative_level.country) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @administrative_level.errors.to_xml }
      end
    end
  end

  # DELETE /administrative_levels/1
  # DELETE /administrative_levels/1.xml
  def destroy
    @administrative_level = AdministrativeLevel.find(params[:id])
    @country = @administrative_level.country if @country.nil?
    level = @administrative_level.level
    parent_level = AdministrativeLevel.find(:first, :conditions => { :country_id => @country.id, :level => level-1 })
    AdministrativeUnit.find(:all, :conditions => { :administrative_level_id => @administrative_level.id }).each do |unit|
      parent_unit = unit.parent
      unit.children.each do |child|
        child.parent = parent_unit
        child.save
      end      
      MediaAdministrativeLocation.update_all("administrative_unit_id = #{parent_unit.id}", {:administrative_unit_id => unit.id})
    end
    @administrative_level.destroy
    AdministrativeLevel.update_all('level = level - 1', ['country_id = ? AND level > ?', @country, level])

    respond_to do |format|
      format.html { redirect_to country_administrative_levels_url(@country) }
      format.xml  { head :ok }
    end
  end
  
  private
  
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