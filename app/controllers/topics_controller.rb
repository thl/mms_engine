class TopicsController < ApplicationController
  helper :media
  caches_page :index, :show, :pictures, :videos, :documents
  
  def index
    @topics = Topic.roots_with_media
  end
    
  def show
    @topic = Topic.find(params[:id])
    medium_id = params[:medium_id]
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    if @medium.nil?
      @current = @topic.ancestors.collect{|c| c.id.to_i}
      @current << @topic.id.to_i
      @topics = Topic.roots_with_media
    end
    @pictures = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
    @videos = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
    @documents = @topic.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
    title = @topic.title
    @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
    @more = { :category_id => @topic.id, :type => '' }
    render_media
  end
  
  def pictures
    get_media_by_type('Picture')
    @title = ts :in, :what => Picture.human_name(:count => :many).titleize, :where => @topic.title
    render_media
  end
  
  def videos
    get_media_by_type('Video')
    @title = ts :in, :what => Video.human_name(:count => :many).titleize, :where => @topic.title
    render_media
  end
  
  def documents
    get_media_by_type('Document')
    @title = ts :in, :what => Document.human_name(:count => :many).titleize, :where => @topic.title
    render_media
  end
  
  def expand
    render :partial => 'expanded', :object => Topic.find(params[:id]), :locals => {:margin_depth => params[:margin_depth].to_i}
  end

  def contract
    render :partial => 'contracted', :object => Topic.find(params[:id]), :locals => {:margin_depth => params[:margin_depth].to_i}
  end
  
  private
  
  def get_media_by_type(type)
    @topic = Topic.find(params[:id])
    @medium_pages = Paginator.new self, @topic.media_count(type), Medium::FULL_COLS * Medium::FULL_ROWS, params[:page]
    @media = @topic.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset, type)
    @pagination_params = { :category_id => @topic.id, :type => type }
  end
  
  def render_media
    get_tab_options
    if request.xhr?
      render :update do |page|
        if !@medium.nil?
          page.replace_html 'primary', :partial => 'media/show'
        end
        page.replace_html 'secondary', :partial => 'media_index'
        page.call 'ActivateThlPopups', '#secondary'
        page.call 'tb_init', 'a.thickbox, area.thickbox, input.thickbox'
      end
    else
      respond_to do |format|
        format.html do
          if @topics.nil?
            render(:action => @medium.nil? ? 'show' : 'show_for_medium')
          else
            render :action => 'index'
          end
        end
      end
    end
  end
  
  def get_tab_options
    @tab_options ||= {}
    @tab_options[:counts] = tab_counts_for_element(@topic)
    @tab_options[:urls] = tab_urls_for_element(@topic) 
  end
end