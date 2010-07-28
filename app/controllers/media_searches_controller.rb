class MediaSearchesController < AclController
  helper :media
  
  def initialize
    super
    @guest_perms += ['media_searches/new', 'media_searches/create']
    @current_tab_id = :search
  end
  
  # GET /media_searches
  # GET /media_searches.xml
  def index #NOT USED
    redirect_to new_media_search_url
  end

  # GET /media_searches/1
  # GET /media_searches/1.xml
  def show #NOT USED
    redirect_to new_media_search_url
  end

  # GET /media_searches/new
  def new #main media search page
    @media_search = MediaSearch.new({:title => '', :type => 'simple'})
  end

  # GET /media_searches/1;edit
  def edit #NOT USED
    redirect_to new_media_search_url
  end

  # POST /media_searches
  # POST /media_searches.xml
  def create # actually creates the new search query and displays results
    calculate_media_search
    calculate_sorrounding_search
    if request.xhr?
      render :update do |page|
        page.replace_html 'primary', :partial => 'media_searches/tabulated_search_results'
      end
    else
      respond_to do |format|
        format.html # create.rhtml
        #format.xml  { render :xml => TODO }
      end
    end    
  end
  
  def index
    calculate_media_search
    @media_type = params[:media_type]
    @medium_pages = Paginator.new self, Medium.count_media_search(@media_search, @media_type), 20, params[:page]
    @media = Medium.paged_media_search(@media_search, @medium_pages.items_per_page, @medium_pages.current.offset, @media_type)
    @title = "Media about \"#{@media_search.title}\""
    if request.xhr?
      respond_to do |format|
        format.html { render :partial => @media_type=='Document' ? 'media_searches/paged_documents' : 'media_searches/paged_media' }
        #format.xml  { render :xml => TODO }
      end
    else
      calculate_sorrounding_search
      respond_to do |format|
        format.html { render :action => @media_type=='Document' ? 'paged_documents' : 'paged_media' }
        #format.xml  { render :xml => TODO }
      end
    end
  end

  # PUT /media_searches/1
  # PUT /media_searches/1.xml
  def update #NOT USED
    redirect_to new_media_search_url
  end

  # DELETE /media_searches/1
  # DELETE /media_searches/1.xml
  def destroy #NOT USED
    redirect_to new_media_search_url
  end
  
  private
  
  def calculate_media_search
    media_search_param = params[:media_search]
    @media_search = media_search_param.blank? ? MediaSearch.new(:title => params[:media_search_title], :type => params[:media_search_type]) : MediaSearch.new(media_search_param)
    @pagination_params = { :media_search_title => @media_search.title, :media_search_type => @media_search.type, :media_type => params[:media_type] }
  end
  
  def calculate_sorrounding_search
    @picture_count = Medium.count_media_search(@media_search, 'Picture')
    @video_count = Medium.count_media_search(@media_search, 'Video')
    @document_count = Medium.count_media_search(@media_search, 'Document')
    @administrative_units = AdministrativeUnit.find(:all, :conditions => [Util.search_condition_string(@media_search.type, 'title', true), @media_search.title])
    @keywords = Keyword.find(:all, :conditions => [Util.search_condition_string(@media_search.type, 'title', true), @media_search.title])
  end
end