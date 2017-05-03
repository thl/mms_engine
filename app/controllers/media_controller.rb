class MediaController < AclController
  caches_page :show, if: Proc.new { |c| c.request.format.xml? || c.request.format.json?}
  caches_page :index, if: Proc.new { |c| c.request.format.xml? || c.request.format.json?}
  caches_action :external, cache_path: Proc.new { |c| c.request.path }, if: Proc.new { |c| c.request.format.html?}
  cache_sweeper :medium_sweeper, only: [:update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:external]
  
  # Adding redundant candidates (e.g. category_id and :topic_id) for now to prevent errors, but these should be consolidated
  MEDIA_TYPES = {picture: Picture, video: Video, document: Document}

  def initialize
    super
    @guest_perms += ['media/goto', 'media/large', 'media/full_size', 'media/external']
  end
  
  # GET /media[?keyword_id=1]
  # GET /media.xml[?keyword_id=1]
  def index
    begin
      keyword_id = params[:keyword_id]
      @type = params[:type]
      if !keyword_id.blank?
        @keyword = Keyword.find(keyword_id)
        @media = @keyword.media.paginate(:per_page => Medium::COLS * Medium::ROWS, :page => params[:page]) # :total_entries => @keyword.media.size
        @title = "#{Medium.model_name.human(:count => :many).titleize} Associated with Keyword \"#{@keyword.title}\"".s
      else
        if !@type.blank?
          @media = Medium.where(:type => @type).order('created_on DESC')
          @media = @media.send(session[:filter]) if !session[:filter].blank?
          @media = @media.paginate(:per_page => Medium::FULL_COLS * Medium::FULL_ROWS, :page => params[:page]) # :total_entries => Medium.where(:type => @type).count
          @title = @type.constantize.model_name.human.titleize.pluralize
        else
          #@pictures = Picture.all.limit(Medium::COLS * Medium::PREVIEW_ROWS).order('RAND()')
          # TODO: railsify the sql query below
          @pictures = Picture.find_by_sql ["SELECT * FROM media m JOIN (SELECT MAX(ID) AS ID FROM media) AS m2 ON m.ID >= FLOOR(m2.ID*RAND()) where m.type = 'Picture' LIMIT ?", Medium::COLS * Medium::PREVIEW_ROWS]
          @videos = Video.order('RAND()').limit(Medium::COLS)
          @documents = Document.order('RAND()').limit(Medium::COLS)
          @online_resources = OnlineResource.order('RAND()').limit(Medium::COLS)
          @titles = { :picture => ts(:daily, :what => Picture.model_name.human(:count => :many).titleize), :video => ts(:daily, :what => Video.model_name.human(:count => :many).titleize), :document => ts(:daily, :what => Document.model_name.human(:count => :many).titleize), :online_resource => ts(:daily, :what => OnlineResource.model_name.human(:count => :many).titleize) }
          @more = { :type => '' }
        end
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to media_path
    else
      respond_to do |format|
        format.html do
          @media_search = MediaSearch.new({:title => '', :type => 'simple'})
          @current_tab_id = :home
          @current_tab_id = @type.underscore.to_sym unless @type.blank?
          if defined? @media.offset
            if @type == 'Document'
              render 'documents/paged_index_full'
            elsif @type == 'OnlineResource'
                render 'online_resources/paged_index_full'
            else
              if @type.blank?
                calculate_keyword_font_sizes
                render 'paged_index'
              else
                render 'paged_index_full'
              end
            end
          else
            calculate_keyword_font_sizes
            # render index.rhtml
          end
        end
        format.js # index.js.erb
        format.xml  do
          @media = Medium.all.order('id')
          render :xml => @media
        end
        format.json do
          @media = Medium.all.order('id')
          render :json => @media #Hash.from_xml(render_to_string(:action => 'index.xml.builder'))
        end
      end
    end
  end

  # GET /media/1
  # GET /media/1.xml
  def show
    @medium = Medium.find(params[:id]) 
    @tab_options ||= {}
    @tab_options[:entity] = @medium
    respond_to do |format|
      format.html do # show.rhtml
        @pictures = Picture.all.order('RAND()').limit(Medium::COLS * Medium::PREVIEW_ROWS)
        @videos = Video.all.order('RAND()').limit(1)
        @documents = Document.all.order('RAND()').limit(1)
        @titles = { :picture => ts(:daily, :what => Picture.model_name.human(:count => :many).titleize), :video => ts(:daily, :what => Video.model_name.human(:count => :many).titleize), :document => ts(:daily, :what => Document.model_name.human(:count => :many).titleize) }
        @more = { :type => '' }
      end
      format.js
      format.xml  #{ render :xml => @medium.to_xml }
      format.json { render :json => Hash.from_xml(render_to_string(:action => 'show.xml.builder')) }
    end
  end
  
  # GET /media/1
  # GET /media/1.xml
  def external
    @medium = Medium.find(params[:id])
    respond_to do |format|
      format.html { render 'og_external', layout: false  }
      format.js #{render 'external'}
    end
  end
  
  # GET /media/1/large
  # GET /media/1/large.xml
  def large
    @medium = Medium.find(params[:id])    
    respond_to do |format|
      format.html { render :template => 'pictures/large' }# large.rhtml
    end
  end

  # GET /media/1/full_size
  # GET /media/1/full_size.xml
  def full_size
    @medium = Medium.find(params[:id])    
    respond_to do |format|
      format.html { render :partial => 'pictures/full_size' }# large.rhtml
    end
  end
  
  # POST /media/goto
  def goto
    goto = params[:goto]
    media_id = goto[:media_id]
    @medium = Medium.find(media_id)
    respond_to do |format|
      format.html { redirect_to medium_url(@medium) }
      format.js   # goto.js.erb
    end
  end

  # GET /media/1;edit
  def edit
    @capture_device_models = CaptureDeviceMaker.all.order('title').collect{|maker| maker.capture_device_models}.flatten
    @media_publisher = MediaPublisher.all
    @medium = Medium.find(params[:id])
    @photographers = AuthenticatedSystem::Person.all.order('fullname')
    @quality_types = QualityType.all.order('id')
    @recording_orientations = RecordingOrientation.all.order('title')
    @resource_types = Topic.find(2636).children
    @root_topics = Topic.roots
  end

  # PUT /media/1
  # PUT /media/1.xml
  def update
    @medium = Medium.find(params[:id])
    params_medium = params.require(:medium).permit(:recording_note, :resource_type_id, :photographer_id, :taken_on, :partial_taken_on, :capture_device_model_id,
    :quality_type_id, :private_note, :rotation, web_address_attributes: [:parent_resource_id, :url])
    respond_to do |format|
      params_web_address = params_medium.delete(:web_address_attributes)
      @medium.attributes = params_medium
      @medium.web_address.attributes = params_web_address if !params_web_address.nil?
      @medium.ingest_taken_on(params_medium)
      is_picture = @medium.instance_of? Picture
      redo_thumbs = @medium.rotation_changed? if is_picture
      if @medium.save # @medium.update_attributes(params[:medium])
        @medium.update_thumbnails if is_picture && redo_thumbs
        flash[:notice] = ts('edit.successful', :what => Medium.model_name.human.capitalize)
        format.html { redirect_to medium_url(@medium) }
        format.xml  { head :ok }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.all.order('title').collect{|maker| maker.capture_device_models}.flatten
          @media_publisher = MediaPublisher.all
          @photographers = AuthenticatedSystem::Person.all.order('fullname')
          @quality_types = QualityType.all.order('id')
          @recording_orientations = RecordingOrientation.all.order('title')
          @resource_types = Topic.find(2636).children
          @root_topics = Topic.roots          
          render :action => 'edit'
        end
        format.xml  { render :xml => @medium.errors.to_xml }
      end
    end
  end

  # DELETE /media/1
  # DELETE /media/1.xml
  def destroy
    @medium = Medium.find(params[:id])
    @medium.destroy

    respond_to do |format|
      format.html { redirect_to media_url }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def calculate_keyword_font_sizes
    @keywords = Keyword.all_tabulated_by_media
    count = @keywords.collect{ |k| k.counted_media.to_i}
    min = count.min
    min = 0 if min.nil?
    max = count.max
    max = 0 if max.nil?
    @keyword_font_size = Hash.new
    font_diff = Util::MAX_FONT_SIZE - Util::MIN_FONT_SIZE
    count_diff = max - min
    count_diff = font_diff if count_diff == 0
    @keywords.each { |k| @keyword_font_size[k.id] = (k.counted_media.to_i - min)*font_diff/count_diff + Util::MIN_FONT_SIZE }
  end
end
