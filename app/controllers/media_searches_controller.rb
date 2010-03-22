class MediaSearchesController < AclController
  helper :media
  
  def initialize
    super
    @guest_perms += ['media_searches/new', 'media_searches/create']
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
    @media_search = MediaSearch.new(params[:media_search])
    @medium_pages = Paginator.new self, Medium.count_media_search(@media_search), 9, params[:page]
    @media = Medium.paged_media_search(@media_search, @medium_pages.items_per_page, @medium_pages.current.offset)
    @administrative_units = AdministrativeUnit.find(:all, :conditions => [Util.search_condition_string(@media_search.type, 'title', true), @media_search.title])
    @keywords = Keyword.find(:all, :conditions => [Util.search_condition_string(@media_search.type, 'title', true), @media_search.title])
    @pagination_prev_url = { :page => @medium_pages.current.previous }
    @pagination_next_url = { :page => @medium_pages.current.next }
    @pagination_params = Hash.new
    @title = "Media about \"#{@media_search.title}\""
    respond_to do |format|
      format.html # create.rhtml
      #format.xml  { render :xml => TODO }
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
end
