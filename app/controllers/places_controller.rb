class PlacesController < ApplicationController
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

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/new
  # GET /places/new.xml
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.xml
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        flash[:notice] = 'Place was successfully created.'
        format.html { redirect_to(@place) }
        format.xml  { render :xml => @place, :status => :created, :location => @place }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.xml
  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        format.html { redirect_to(@place) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @place.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.xml
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to(places_url) }
      format.xml  { head :ok }
    end
  end
end
