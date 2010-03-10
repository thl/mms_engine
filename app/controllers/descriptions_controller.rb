class DescriptionsController < AclController
  helper :media
  before_filter :find_medium
  
  # GET /media/1/descriptions
  # GET /media/1/descriptions.xml
  def index
    if !@medium.nil?
      @descriptions= @medium.descriptions      
      respond_to do |format|
        format.html # index.rhtml
        format.xml  { render :xml => @descriptions.to_xml }
      end
    end
  end


  # GET /media/1/descriptions/1
  # GET /media/1/descriptions/1.xml
  def show
    if !@medium.nil?
      @description = @medium.descriptions.find(params[:id])    
      respond_to do |format|
        format.html # show.rhtml
        format.xml  { render :xml => @description.to_xml }
      end
    end
  end

  # GET /media/1/descriptions/new
  def new
    if !@medium.nil?
      @description_types = DescriptionType.find(:all)
      @languages = ComplexScripts::Language.find(:all, :order => 'title')
      language = ComplexScripts::Language.find_iso_code(I18n.locale)
      @description = Description.new(:language => language, :description_type => @description_types.first, :creator => current_user.person)
    end
  end

  # GET /media/1/descriptions/1;edit
  def edit
    if !@medium.nil?
      @description_types = DescriptionType.find(:all)
      @languages = ComplexScripts::Language.find(:all, :order => 'title')
      @description = @medium.descriptions.find(params[:id])
    end
  end

  # POST /media/1/descriptions
  # POST /media/1/descriptions.xml
  def create
    if !@medium.nil?
      @description = Description.new(params[:description])
      success = @description.save
      @medium.descriptions << @description if success
      
      respond_to do |format|
        if success
          flash[:notice] = ts('new.successful', :what => Description.human_name.capitalize)
          format.html { redirect_to edit_medium_url(@medium) }
          format.xml  { head :created, :location => medium_description_url(@medium, @description) }
        else
          @description_types = DescriptionType.find(:all)
          @languages = ComplexScripts::Language.find(:all, :order => 'title')
          format.html { render media_url }
          format.xml  { render :xml => @description.errors.to_xml }
        end
      end
    end
  end  

  # PUT /media/1/descriptions/1
  # PUT /media/1/descriptions/1.xml
  def update
    if !@medium.nil?
      @description = Description.find(params[:id])
      params_description = params[:description]
      if params_description[:title]==@description.title || @description.media.size==1
        success = @description.update_attributes(params_description)
      else
        @medium.descriptions.delete(@description)
        @description = Description.new(params_description)
        @medium.descriptions << @description
        success = @description.save
      end      
      
      respond_to do |format|
        if success
          flash[:notice] = ts('edit.successful', :what => Description.human_name.capitalize)
          format.html { redirect_to edit_medium_url(@medium) }
          format.xml  { head :ok }
        else
          format.html { render :action => 'edit' }
          format.xml  { render :xml => @description.errors.to_xml }
        end
      end
    end
  end

  # DELETE /media/1/descriptions/1
  # DELETE /media/1/descriptions/1.xml
  def destroy
    if !@medium.nil?
      @description = @medium.descriptions.find(params[:id])
      @description.destroy

      respond_to do |format|
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      end
    end
  end
  
  private
  
  def find_medium
    begin
      medium_id = params[:medium_id]
      @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    rescue ActiveRecord::RecordNotFound
      @medium = nil
    end
    if @medium.nil?
      flash[:notice] = 'Attempt to access invalid medium.'
      redirect_to media_path
    end
  end
end