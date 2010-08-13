class PlacesController < ApplicationController
  helper :media
  
  # To show browsing panel for admin units:
  # GET /locations
  # GET /locations.xml
  # 
  # To show all locations for a medium: 
  # GET /locations?medium_id=1
  # GET /locations.xml?medium_id=1
  # 
  # To show browsing panel defaulting to a specific unit expanded
  # on the left panel and its media on the right panel:
  # GET /locations?administrative_unit_id=1
  # GET /locations.xml?administrative_unit_id=1
  # 
  # To show specific medium on the left panel and
  # the media of a specific unit on the right panel:
  # GET /locations?medium_id=1&administrative_unit_id=2
  # GET /locations.xml?medium_id=1&administrative_unit_id=2
  def index
    medium_id = params[:medium_id]
    element_id = params[@element_name.to_sym]
    type = params[:type]
    @medium = nil
    @media = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      else
        @associations = @association_model.find_all_by_medium(@medium)
      end
    end
    no_media = true
    if !element_id.blank?
      begin
        @element = @model.find(element_id)
      rescue ActiveRecord::RecordNotFound
        @current = nil
        @media = nil
      else
        descendant_ids = @element.descendants
        no_media = false
        if type.blank?
          @pictures = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
          @videos = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
          @documents = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
          title = @element.title
          @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
          @more = { @element_name.to_sym => element_id, :type => '' }  
        else
         @medium_pages = Paginator.new self, @model.count_media(descendant_ids), Medium::ROWS * Medium::COLS, params[:page]
         @media = @element.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset)
         @pagination_params = { @element_name.to_sym => @element.id }
         @pagination_prev_url = { @element_name.to_sym => @element.id, :page => @medium_pages.current.previous }
         @pagination_next_url = { @element_name.to_sym => @element.id, :page => @medium_pages.current.next }
         @title = "Media in #{@element.title}"
        end
        if @medium.nil?
          @current = @element.ancestors.collect{|c| c.id}
          @current << @element.id
        end
      end
    end
    @countries = Country.find(:all, :order => '`title`') if @medium.nil?
    respond_to do |format|
      format.html do # index.rhtml
        if no_media
          if @medium.nil?
            render :template => 'locations/general_index'
          else
            render :template => 'main/hierarchy/mixed_associations/specific_index'
          end
        elsif @medium.nil?
          render :template => 'locations/general_index'
        else
          render :template => 'main/hierarchy/mixed_associations/general_index_for_medium'
        end
      end
      format.xml do
        associations = @association_model.find(:all)
        render :xml => associations.to_xml
      end
    end
  end
  
  # GET /places/1
  # GET /places/1.xml
  def show
    @place = Place.find(params[:id])
    medium_id = params[:medium_id]
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    @pictures = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
    @videos = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
    @documents = @place.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
    title = @place.header
    @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
    @more = { :feature_id => @place.fid, :type => '' }    
    if request.xhr?
      render :update do |page|
        if !@medium.nil?
          page.replace_html 'primary', :partial => 'media/show'
        end
        page.replace_html 'secondary', :partial => 'media_index'
        page.call 'ActivateThlPopups', '#secondary'
      end
    else
      respond_to { |format| format.html { render(:action => 'show_for_medium') if !@medium.nil? } }
    end
  end
end