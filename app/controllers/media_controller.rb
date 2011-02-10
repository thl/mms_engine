class MediaController < AclController
  caches_page :show, :if => :api_response?.to_proc
  cache_sweeper :medium_sweeper, :only => [:update, :destroy]
  
  # Adding redundant candidates (e.g. category_id and :topic_id) for now to prevent errors, but these should be consolidated
  ELEMENT_CANDIDATES = {:category_id => {:class => Topic, :association => 'topics', :name => 'topic'}, :topic_id => {:class => Topic, :association => 'topics', :name => 'topic'}, :feature_id => {:class => Place, :association => 'locations', :name => 'location'}, :place_id => {:class => Place, :association => 'locations', :name => 'location'}}
  MEDIA_TYPES = {:picture => Picture, :video => Video, :document => Document}

  def initialize
    super
    @guest_perms += ['media/goto', 'media/large', 'media/full_size']
  end
  
  # GET /media[?administrative_unit_id=1][&type=Type]
  # GET /media.xml[?administrative_unit_id=1]
  # GET /media[?collection_id=1]
  # GET /media.xml[?collection_id=1]
  # GET /media[?ethnicity_id=1]
  # GET /media.xml[?ethnicity_id=1]
  # GET /media[?subject_id=1]
  # GET /media.xml[?subject_id=1]
  # GET /media[?keyword_id=1]
  # GET /media.xml[?keyword_id=1]
  def index
    begin
      keyword_id = params[:keyword_id]
      type = params[:type]
      @pagination_params = Hash.new
      element_id = nil
      element_name = nil
      ELEMENT_CANDIDATES.each_key do |element_name|
        element_id = params[element_name]
        next if element_id.blank?
        break
      end
      if !element_id.blank?
        element_class = ELEMENT_CANDIDATES[element_name][:class]
        @element = element_class.find(element_id)
        @human_name = ELEMENT_CANDIDATES[element_name][:name]
        @controller_name = ELEMENT_CANDIDATES[element_name][:association]
        @element_name = element_name.to_s
        if type.blank?
          @pictures = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
          @videos = @element.paged_media(Medium::COLS, nil, 'Video')
          @documents = @element.paged_media(Medium::COLS, nil, 'Document')
          title = @element.title
          @titles = Hash.new
          MEDIA_TYPES.each{ |key, value| @titles[key] = ts(:in, :what => value.human_name(:count => :many).titleize, :where => title) }
          @more = { element_name => element_id, :type => '' }
          if @controller_name == 'locations'
            @place = @element
            partial = 'places/show'
          elsif @controller_name == 'topics'
            partial = 'topics/show'
          else
            partial = 'main/hierarchy/associations/general_index'
          end            
        else
          @tab_options ||= {}
          @tab_options[:counts] = tab_counts_for_element(@element)
          @tab_options[:urls] = tab_urls_for_element(@element)
          @tab_options[:urls][:browse] = polymorphic_url(@element)
          # Need to use .fid if the element is a Place
          @tab_options[:urls][:browse] = place_url(@element.fid) if @element.class.name == 'Place'
          @medium_pages = Paginator.new self, @element.media_count(type), Medium::FULL_COLS * Medium::FULL_ROWS, params[:page]
          @media = @element.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset, type)
          @pagination_params[element_name] = element_id
          @title = ts(:in, :what => MEDIA_TYPES[type.downcase.to_sym].human_name(:count => :many).titleize, :where => @element.title)
        end
        if !['locations', 'topics'].include? @controller_name
          @current = @element.ancestors.collect{|c| c.id.to_i}
          @current << @element.id.to_i
          @elements = element_class.root.children
        end
      elsif !keyword_id.blank?
        @keyword = Keyword.find(keyword_id)
        @medium_pages = Paginator.new self, @keyword.media.size, Medium::COLS * Medium::ROWS, params[:page]
        @media = @keyword.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset)
        @pagination_params[:keyword_id] = @keyword.id
        @title = ts(:in, :what => Medium.human_name(:count => :many).titleize, :where => ts(:keyword, :what => @keyword.title))
      else
        if !type.blank?
          @medium_pages = Paginator.new self, Medium.count(:conditions => { :type => type }), Medium::FULL_COLS * Medium::FULL_ROWS, params[:page]
          @media = Medium.find(:all, :conditions => {:type => type}, :limit => @medium_pages.items_per_page, :offset => @medium_pages.current.offset, :order => 'created_on DESC')
          @title = type.constantize.human_name.titleize.pluralize
        else
          #@pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
          # TODO: railsify the sql query below
          @pictures = Picture.find_by_sql ["SELECT * FROM media m JOIN (SELECT MAX(ID) AS ID FROM media) AS m2 ON m.ID >= FLOOR(m2.ID*RAND()) where m.type = 'Picture' LIMIT ?", Medium::COLS * Medium::PREVIEW_ROWS]
          @videos = Video.find(:all, :order => 'RAND()', :limit => Medium::COLS)
          @documents = Document.find(:all, :order => 'RAND()', :limit => Medium::COLS)
          @titles = { :picture => ts(:daily, :what => Picture.human_name(:count => :many).titleize), :video => ts(:daily, :what => Video.human_name(:count => :many).titleize), :document => ts(:daily, :what => Document.human_name(:count => :many).titleize) }
          @more = { :type => '' }
        end
      end
      @pagination_params[:type] = type if !@medium_pages.nil? && !type.blank?
    rescue ActiveRecord::RecordNotFound
      redirect_to media_path
    else
      rendering_main = !request.xhr? || (@media.nil? && @pictures.nil? && @videos.nil? && @documents.nil?)
      if rendering_main
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
        @media_search = MediaSearch.new({:title => '', :type => 'simple'})
        @current_tab_id = :home
      end
      @current_tab_id = type.underscore.to_sym unless type.blank?
      if request.xhr?
        render :update do |page|
          if rendering_main
            page.replace_html 'primary', :partial => 'media/main'
          else
            if @medium_pages.nil?
              page.replace_html 'secondary', :partial => 'media/index'
              page.replace_html('navigation', :partial => partial) if !element_id.blank?
            else
              page.replace_html 'secondary', :partial => type == 'Document' ? 'documents/paged_index' : 'media/paged_index_full'
            end
            page.call 'ActivateThlPopups', '#secondary'
            page.call 'tb_init', 'a.thickbox, area.thickbox, input.thickbox'
          end
        end
      else
        respond_to do |format|
          format.html do
            if !@medium_pages.nil?
              if type == 'Document'
                render :template => type.blank? ? 'documents/paged_index' : 'documents/paged_index_full'
              else
                render :action => type.blank? ? 'paged_index' : 'paged_index_full'
              end
            end # else render index.rhtml
          end
          format.xml  { render :xml => @media.to_xml }
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
    if request.xhr?
      render :partial => 'show'
    else      
      @pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
      @videos = Video.find(:all, :order => 'RAND()', :limit => 1)
      @documents = Document.find(:all, :order => 'RAND()', :limit => 1)
      @titles = { :picture => ts(:daily, :what => Picture.human_name(:count => :many).titleize), :video => ts(:daily, :what => Video.human_name(:count => :many).titleize), :document => ts(:daily, :what => Document.human_name(:count => :many).titleize) }
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
    if request.xhr?
      render :partial => 'show'
    else
      redirect_to medium_url(@medium)
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
      if @medium.update_attributes(params[:medium])
        flash[:notice] = ts('edit.successful', :what => Medium.human_name.capitalize)
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
end
