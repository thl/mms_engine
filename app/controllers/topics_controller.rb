class TopicsController < AclController
  helper :media
  cache_sweeper :media_category_association_sweeper, :only => [:destroy]
  
  def initialize
    super
    @current_tab_id = :browse
    @guest_perms += ['topics/pictures', 'topics/videos', 'topics/documents', 'topics/expand', 'topics/contract']
  end
  
  # GET /topics
  def index
    redirect_to topic_url(2823)
  end
    
  # GET /topics/1
  def show
    @topic = Topic.find(params[:id])
    @root = @topic.root
    medium_id = params[:medium_id]
    @margin_depth = params[:margin_depth].to_i
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    @pictures = @topic.media(:type => 'Picture').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    @videos = @topic.media(:type => 'Video').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    @documents = @topic.media(:type => 'Document').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    render_media
  end
  
  # DELETE /topics/1
  def destroy
    @topic = Topic.find(params[:id])
    MediaCategoryAssociation.where(category_id: @topic.id).destroy_all
    redirect_to topic_url(@topic.parent)
  end

  # GET /topics/1/pictures
  def pictures
    get_media_by_type('Picture')
    @title = ts :in, :what => Picture.model_name.human(:count => :many).titleize, :where => @topic.header
    render_media
  end
  
  # GET /topics/1/videos
  def videos
    get_media_by_type('Video')
    @title = ts :in, :what => Video.model_name.human(:count => :many).titleize, :where => @topic.header
    render_media
  end
  
  # GET /topics/1/documents
  def documents
    get_media_by_type('Document')
    @title = ts :in, :what => Document.model_name.human(:count => :many).titleize, :where => @topic.header
    render_media
  end
  
  # GET /topics/1/expand
  def expand
    @topic = Topic.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
  end

  # GET /topics/1/contract
  def contract
    @topic = Topic.find(params[:id])
    @margin_depth = params[:margin_depth].to_i
  end
  
  private
  
  def get_media_by_type(type)
    @topic = Topic.find(params[:id])
    @media = @topic.media(:type => type)
    filter = session[:filter]
    if filter.blank?
      count = @topic.media_count(type)
    else
      @media = @media.send(filter)
      count = @media.count
    end
    @media = @media.paginate(:page => params[:page], :per_page => params[:per_page] || Medium::FULL_COLS * Medium::FULL_ROWS, :total_entries => count)
    @pagination_params = { :category_id => @topic.id, :type => type }
  end
  
  def render_media
    respond_to do |format|
      format.html do
        get_tab_options
        if !@medium.nil?
          render :action => 'show_for_medium'
        elsif !@topic.nil?
          render(:action => @media.nil? ? 'index' : 'show')
        elsif
          render :action => 'index'
        end          
      end
      format.js   { render 'show' }
      format.xml  { render 'show' }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'show.xml.builder')) }
    end
  end
  
  def get_tab_options
    @tab_options ||= {}
    @tab_options[:counts] = tab_counts_for_element(@topic)
    @tab_options[:urls] = tab_urls_for_element(@topic) 
  end
end