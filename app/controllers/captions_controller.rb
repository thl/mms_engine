class CaptionsController < AclController
  helper :media
  before_filter :find_medium
  
  # GET /media/1/captions
  # GET /media/1/captions.xml
  def index
    @captions= @medium.captions      
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @captions.to_xml }
    end
  end

  # GET /media/1/captions/1
  # GET /media/1/captions/1.xml
  def show
    @caption = @medium.captions.find(params[:id])
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @caption.to_xml }
    end
  end

  # GET /media/1/captions/new
  def new
    @description_types = DescriptionType.order('title')
    @languages = ComplexScripts::Language.order('title')
    language = ComplexScripts::Language.find_iso_code(I18n.locale)
    @caption = Caption.new(:language => language, :description_type => @description_types.first)
    @caption.creator_id = current_user.person.id
  end

  # GET /media/1/captions/1;edit
  def edit
    @description_types = DescriptionType.order('title')
    @languages = ComplexScripts::Language..order('title')
    @caption = @medium.captions.find(params[:id])
  end

  # POST /media/1/captions
  # POST /media/1/captions.xml
  def create
    @caption = Caption.new(params[:caption])
    @caption.creator_id = current_user.person.id
    success = @caption.save
    @medium.captions << @caption if success
    
    respond_to do |format|
      if success
        flash[:notice] = ts('new.successful', :what => Caption.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :created, :location => medium_caption_url(@medium, @caption) }
      else
        @description_types = DescriptionType.order('title')
        @languages = ComplexScripts::Language.order('title')
        format.html { render :action => 'new' }
        format.xml  { render :xml => @caption.errors.to_xml }
      end
    end
  end

  # PUT /media/1/captions/1
  # PUT /media/1/captions/1.xml
  def update
    @caption = @medium.captions.find(params[:id])
    params_caption = params[:caption]
    if params_caption[:title]==@caption.title || @caption.media.size==1
      success = @caption.update_attributes(params_caption)
    else
      @medium.captions.delete(@caption)
      @caption = Caption.new(params_caption)
      @medium.captions << @caption
      success = @caption.save
    end      
    respond_to do |format|
      if success
        flash[:notice] = ts('edit.successful', :what => Caption.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium) }
        format.xml  { head :ok }
      else
        @description_types = DescriptionType.order('title')
        @languages = ComplexScripts::Language.order('title')
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @caption.errors.to_xml }
      end
    end
  end

  # DELETE /media/1/captions/1
  # DELETE /media/1/captions/1.xml
  def destroy
    @caption = @medium.captions.find(params[:id])
    @caption.destroy

    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium) }
      format.xml  { head :ok }
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