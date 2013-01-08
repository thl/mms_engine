class TitlesController < AclController
  helper :media
  before_filter :find_medium
  caches_page :index, :show, :if => Proc.new { |c| c.request.format.xml? }
  cache_sweeper :title_sweeper, :only => [:create, :update, :destroy]
  
  # GET /titles
  # GET /titles.xml
  def index
    @titles = @medium.titles.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @titles }
    end
  end

  # GET /titles/1
  # GET /titles/1.xml
  def show
    @title = Title.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/new
  # GET /titles/new.xml
  def new
    @languages = ComplexScripts::Language.order('title')
    language = ComplexScripts::Language.find_iso_code(I18n.locale)
    @title = @medium.titles.new(:language_id => language.id)
    @title.creator = current_user.person
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @title }
    end
  end

  # GET /titles/1/edit
  def edit
    @languages = ComplexScripts::Language.order('title')
    @title = Title.find(params[:id])      
  end

  # POST /titles
  # POST /titles.xml
  def create
    @title = @medium.titles.new(params[:title])
    @title.creator = current_user.person
    respond_to do |format|
      if @title.save
        flash[:notice] = ts('new.successful', :what => Title.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
        format.xml  { render :xml => @title, :status => :created, :location => medium_title_url(@medium, @title) }
      else
        @languages = ComplexScripts::Language.order('title')
        format.html { render :action => "new" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /titles/1
  # PUT /titles/1.xml
  def update
    @title = Title.find(params[:id])
    respond_to do |format|
      if @title.update_attributes(params[:title])
        flash[:notice] = ts('edit.successful', :what => Title.model_name.human.capitalize)
        format.html { redirect_to edit_medium_url(@medium, :anchor => 'titles') }
        format.xml  { head :ok }
      else
        @languages = ComplexScripts::Language.find(:all, :order => 'title')
        format.html { render :action => "edit" }
        format.xml  { render :xml => @title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /titles/1
  # DELETE /titles/1.xml
  def destroy
    @title = Title.find(params[:id])
    @title.destroy

    respond_to do |format|
      format.html { redirect_to medium_titles_url(@medium) }
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