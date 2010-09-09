class PlacesController < ApplicationController
  helper :media
  include ApplicationHelper
  
  # GET /places/1
  # GET /places/1.xml
  def show
    medium_id = params[:medium_id]
    type = params[:type]
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    @place = Place.find(params[:id])    
    @pictures = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
    @videos = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
    @documents = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
    title = @place.header
    @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
    @more = { :feature_id => @place.fid, :type => '' }
    render_media
  end
  
  def pictures
    get_media_by_type('Picture')
    @title = ts :in, :what => Picture.human_name(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  def videos
    get_media_by_type('Video')
    @title = ts :in, :what => Video.human_name(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  def documents
    get_media_by_type('Document')
    @title = ts :in, :what => Document.human_name(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  private
  
  def get_media_by_type(type)
    @place = Place.find(params[:id])
    @medium_pages = Paginator.new self, @place.media_count(:type => type), Medium::FULL_COLS * Medium::FULL_ROWS, params[:page]
    @media = @place.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset, type)
    @pagination_params = { :feature_id => @place.fid, :type => type }
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
      respond_to { |format| format.html { render(:action => @medium.nil? ? 'show' : 'show_for_medium') } }
    end
  end
  
  def get_tab_options
    @tab_options ||= {}
    @tab_options[:counts] = tab_counts_for_element(@place)
    @tab_options[:urls] = tab_urls_for_element(@place)
  end
end