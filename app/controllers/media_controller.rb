class MediaController < AclController
  caches_page :show, :if => :api_response?.to_proc
  cache_sweeper :medium_sweeper, :only => [:update, :destroy]
  
  # Adding redundant candidates (e.g. category_id and :topic_id) for now to prevent errors, but these should be consolidated
  MEDIA_TYPES = {:picture => Picture, :video => Video, :document => Document}

  def initialize
    super
    @guest_perms += ['media/goto', 'media/large', 'media/full_size']
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
          @media = Medium.where(:type => @type).order('created_on DESC').paginate(:per_page => Medium::FULL_COLS * Medium::FULL_ROWS, :page => params[:page]) # :total_entries => Medium.where(:type => @type).count
          @title = @type.constantize.model_name.human.titleize.pluralize
        else
          #@pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
          # TODO: railsify the sql query below
          @pictures = Picture.find_by_sql ["SELECT * FROM media m JOIN (SELECT MAX(ID) AS ID FROM media) AS m2 ON m.ID >= FLOOR(m2.ID*RAND()) where m.type = 'Picture' LIMIT ?", Medium::COLS * Medium::PREVIEW_ROWS]
          @videos = Video.order('RAND()').limit(Medium::COLS)
          @documents = Document.order('RAND()').limit(Medium::COLS)
          @titles = { :picture => ts(:daily, :what => Picture.model_name.human(:count => :many).titleize), :video => ts(:daily, :what => Video.model_name.human(:count => :many).titleize), :document => ts(:daily, :what => Document.model_name.human(:count => :many).titleize) }
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
        format.xml  { render :xml => @media.to_xml }
      end
    end
  end

  # GET /media/1
  # GET /media/1.xml
  def show
    @medium = Medium.find(params[:id]) 
    @tab_options ||= {}
    @tab_options[:entity] = @medium
    if request.xhr?
      render :partial => 'show'
    else      
      @pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
      @videos = Video.find(:all, :order => 'RAND()', :limit => 1)
      @documents = Document.find(:all, :order => 'RAND()', :limit => 1)
      @titles = { :picture => ts(:daily, :what => Picture.model_name.human(:count => :many).titleize), :video => ts(:daily, :what => Video.model_name.human(:count => :many).titleize), :document => ts(:daily, :what => Document.model_name.human(:count => :many).titleize) }
      @more = { :type => '' }
      respond_to do |format|
        format.html # show.rhtml
        format.xml  #{ render :xml => @medium.to_xml }
      end
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
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @media_publisher = MediaPublisher.find(:all)
    @medium = Medium.find(params[:id])
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')
    @resource_types = Topic.find(2636).children
    @root_topics = Topic.roots
  end

  # PUT /media/1
  # PUT /media/1.xml
  def update
    @medium = Medium.find(params[:id])
    respond_to do |format|
      @medium.attributes=params[:medium]
      is_picture = @medium.instance_of? Picture
      redo_thumbs = @medium.rotation_changed? if is_picture
      if @medium.save # @medium.update_attributes(params[:medium])
        @medium.update_thumbnails if is_picture && redo_thumbs
        flash[:notice] = ts('edit.successful', :what => Medium.model_name.human.capitalize)
        format.html { redirect_to medium_url(@medium) }
        format.xml  { head :ok }
      else
        format.html do
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @media_publisher = MediaPublisher.find(:all)
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')
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
  
  def api_response?
    request.format.xml?
  end
  
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
