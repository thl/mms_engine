class MediaSearchesController < AclController
  @@media_types = {:picture => Picture, :video => Video, :document => Document, :online_resource => OnlineResource}
  helper :media
  
  def initialize
    super
    @guest_perms += ['media_searches/new', 'media_searches/create']
    @current_tab_id = :search
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

  # GET /media_searches
  # GET /media_searches.xml
  def index
    calculate_media_search
    @media_type = params[:media_type]
    if @media_search.title.nil?
      redirect_to new_media_search_url
    else
      per_page = @media_type.blank? ? 20 : Medium::FULL_COLS * Medium::FULL_ROWS
      @media = Medium.media_search(@media_search, @media_type).paginate(:per_page => per_page, :page => params[:page]) # :total_entries => Medium.media_count_search(@media_search, @media_type)
      @pictures = Medium.media_search(@media_search, 'Picture').paginate(:per_page => per_page, :page => params[:page])
      @videos = Medium.media_search(@media_search, 'Video').paginate(:per_page => per_page, :page => params[:page])
      @documents = Medium.media_search(@media_search, 'Document').paginate(:per_page => per_page, :page => params[:page])
      @online_resources = Medium.media_search(@media_search, 'OnlineResource').paginate(:per_page => per_page, :page => params[:page])
      @keywords = Keyword.where([Util.search_condition_string(@media_search.type, 'title', true), @media_search.title])
      @titles = Hash.new
      @@media_types.each{ |key, value| @titles[key] = "#{value.model_name.human(:count => :many).titleize} about \"#{@media_search.title}\"" }
      media_type_display = @media_type.blank? ? 'Media' : @@media_types[@media_type.underscore.to_sym].model_name.human(:count => :many).titleize
      @title = "#{media_type_display} about \"#{@media_search.title}\""
      @tab_options ||= {}
      @tab_options[:counts] = tab_counts_for_search(@media_search)
      @tab_options[:urls] = tab_urls_for_search(@pagination_params)
      @tab_options[:urls][:search] = media_searches_path(@pagination_params.reject{|param,value| param == :media_type})
      @current_tab_id = @media_type.underscore.to_sym unless @media_type.blank?
      respond_to do |format|
        format.html do
          if @media_type.blank?
            render :action => @media_type=='Document' ? 'paged_documents' : 'paged_media'
          else
            render :action => @media_type=='Document' ? 'paged_documents_full' : 'paged_media_full'
          end
        end
        #format.xml  { render :xml => TODO }
        format.js # index.js.erb
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
end