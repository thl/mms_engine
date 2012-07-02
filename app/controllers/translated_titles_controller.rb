class TranslatedTitlesController < AclController
  helper :media
  before_filter :find_medium_and_title  
  
  # GET /translated_titles
  # GET /translated_titles.xml
  def index
    if !@medium.nil? && !@title.nil?
      @translated_titles = @title.translated_titles.all
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @translated_titles }
      end
    end
  end

  # GET /translated_titles/1
  # GET /translated_titles/1.xml
  def show
    if !@medium.nil? && !@title.nil?
      @translated_title = TranslatedTitle.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @translated_title }
      end
    end
  end

  # GET /translated_titles/new
  # GET /translated_titles/new.xml
  def new
    if !@medium.nil? && !@title.nil?
      @languages = ComplexScripts::Language.order('title')
      language = ComplexScripts::Language.find_iso_code(I18n.locale)
      @translated_title = @title.translated_titles.new(:language => language, :creator => current_user.person)
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @translated_title }
      end
    end
  end

  # GET /translated_titles/1/edit
  def edit
    if !@medium.nil? && !@title.nil?
      @languages = ComplexScripts::Language.order('title')
      @translated_title = TranslatedTitle.find(params[:id])
	 end  
  end

  # POST /translated_titles
  # POST /translated_titles.xml
  def create
    if !@medium.nil? && !@title.nil?
      @translated_title = @title.translated_titles.new(params[:translated_title])
      respond_to do |format|
        if @translated_title.save
          flash[:notice] = ts('new.successful', :what => TranslatedTitle.human_name.capitalize)
          format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
          format.xml  { render :xml => @translated_title, :status => :created, :location => @translated_title }
        else
          @languages = ComplexScripts::Language.order('title')
          format.html { render :action => "new" }
          format.xml  { render :xml => @translated_title.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /translated_titles/1
  # PUT /translated_titles/1.xml
  def update
    if !@medium.nil? && !@title.nil?
      @translated_title = TranslatedTitle.find(params[:id])
      respond_to do |format|
        if @translated_title.update_attributes(params[:translated_title])
          flash[:notice] = ts('edit.successful', :what => TranslatedTitle.human_name.capitalize)
          format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
          format.xml  { head :ok }
        else
          @languages = ComplexScripts::Language.order('title')
          format.html { render :action => "edit" }
          format.xml  { render :xml => @translated_title.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /translated_titles/1
  # DELETE /translated_titles/1.xml
  def destroy
    if !@medium.nil? && !@title.nil?
      @translated_title = TranslatedTitle.find(params[:id])
      @translated_title.destroy
      respond_to do |format|
        format.html { redirect_to medium_title_translated_titles_url(@medium, @title) }
        format.xml  { head :ok }
      end
    end
  end
  
  private
  
  def find_medium_and_title
    @medium, @title = nil
    begin
      medium_id = params[:medium_id]
      @medium = Medium.find(medium_id) if !medium_id.blank?
      title_id = params[:title_id]
      @title = Title.find(title_id) if !title_id.blank?
    rescue ActiveRecord::RecordNotFound
    end
    if @medium.nil? || @title.nil?
      flash[:notice] = 'Attempt to access invalid object.'
      redirect_to media_path
    end
  end
end