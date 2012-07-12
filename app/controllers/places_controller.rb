class PlacesController < ApplicationController
  helper :media
  
  # GET /places/1
  # GET /places/1.xml
  def show
    medium_id = params[:medium_id]
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    @place = Place.find(params[:id])    
    @pictures = @place.media(:type => 'Picture').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    @videos = @place.media(:type => 'Video').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    @documents = @place.media(:type => 'Document').limit(Medium::COLS * Medium::PREVIEW_ROWS)
    render_media
  end
  
  def pictures
    get_media_by_type('Picture')
    @title = ts :in, :what => Picture.model_name.human(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  def videos
    get_media_by_type('Video')
    @title = ts :in, :what => Video.model_name.human(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  def documents
    get_media_by_type('Document')
    @title = ts :in, :what => Document.model_name.human(:count => :many).titleize, :where => @place.header
    render_media
  end
  
  private
  
  def get_media_by_type(type)
    @place = Place.find(params[:id])
    @media = @place.media(:type => type).paginate(:page => params[:page], :per_page => Medium::FULL_COLS * Medium::FULL_ROWS, :total_entries => @place.media_count(type))
    @pagination_params = { :feature_id => @place.fid, :type => type }
  end
  
  def render_media
    get_tab_options
    respond_to do |format|
      format.html { render(:action => @medium.nil? ? 'show' : 'show_for_medium') }
      format.js   { render 'show' }
    end
  end
  
  def get_tab_options
    @tab_options ||= {}
    @tab_options[:counts] = tab_counts_for_element(@place)
    @tab_options[:urls] = tab_urls_for_element(@place)
  end
end