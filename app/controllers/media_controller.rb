class MediaController < AclController
  @@element_candidates = {:administrative_unit_id => {:class => AdministrativeUnit, :association => 'media_administrative_locations', :name => 'administrative location'}, :collection_id => {:class => Collection, :association => 'media_collection_associations', :name => 'collection'}, :ethnicity_id => {:class => Ethnicity, :association => 'media_ethnicity_associations', :name => 'socio-cultural group'}, :subject_id => {:class => Subject, :association => 'media_subject_associations', :name => 'subject'}}

  def initialize
    super
    @guest_perms += ['media/goto', 'media/large']
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
      @pagination_prev_url = Hash.new
      @pagination_next_url = Hash.new
      element_id = nil
      element_name = nil
      @@element_candidates.each_key do |element_name|
        element_id = params[element_name]
        next if element_id.blank?
        break
      end
      if !element_id.blank?
        element_class = @@element_candidates[element_name][:class]
        @element = element_class.find(element_id)
        @human_name = @@element_candidates[element_name][:name]
        @controller_name = @@element_candidates[element_name][:association]
        @element_name = element_name.to_s
        if type.blank?
          @pictures = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
          @videos = @element.paged_media(Medium::COLS, nil, 'Video')
          #@documents = @element.paged_media(Medium::COLS, nil, 'Document')
          title = @element.title
          @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
          @more = { element_name => element_id, :type => '' }
          if @controller_name == 'media_administrative_locations'
            @countries = Country.find(:all, :order => '`title`')
            partial = 'media_administrative_locations/general_index'
          else
            partial = 'main/hierarchy/associations/general_index'
          end            
        else
          @medium_pages = Paginator.new self, @element.count_inherited_media(type), Medium::COLS * Medium::ROWS, params[:page]
          @media = @element.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset, type)
          @pagination_params[element_name] = element_id
          @pagination_prev_url[element_name] = element_id
          @pagination_next_url[element_name] = element_id
          @title = ts(:in, :what => type.pluralize, :where => @element.title)
        end
        @current = @element.ancestors.collect{|c| c.id.to_i}
        @current << @element.id.to_i
        @elements = element_class.root.children
      elsif !keyword_id.blank?
        @keyword = Keyword.find(keyword_id)
        @medium_pages = Paginator.new self, @keyword.media.size, Medium::COLS * Medium::ROWS, params[:page]
        @media = @keyword.paged_media(@medium_pages.items_per_page, @medium_pages.current.offset)
        @pagination_params[:keyword_id] = @keyword.id
        @pagination_prev_url[:keyword_id] = @keyword.id
        @pagination_next_url[:keyword_id] = @keyword.id
        @title = ts(:in, :what => Medium.human_name(:count => :many).titleize, :where => ts(:keyword, :what => @keyword.title))
      else
        if request.xhr?
          if !type.blank?
            @medium_pages = Paginator.new self, Medium.count(:conditions => { :type => type }), Medium::COLS * Medium::ROWS, params[:page]
            @media = Medium.find(:all, :conditions => {:type => type}, :limit => @medium_pages.items_per_page, :offset => @medium_pages.current.offset)
            @title = ts(:all, :what => type.pluralize)
          end
        else
          @pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
          @videos = Video.find(:all, :order => 'RAND()', :limit => 1)
          #@documents = Document.find(:all, :order => 'RAND()', :limit => 1)
          @titles = { :picture => ts(:daily, :what => Picture.human_name(:count => :many).titleize), :video => ts(:daily, :what => Video.human_name(:count => :many).titleize), :document => ts(:daily, :what => Document.human_name(:count => :many).titleize) }
          @more = { :type => '' }
        end
      end
      if !@medium_pages.nil?
        @pagination_prev_url[:page] = @medium_pages.current.previous
        @pagination_next_url[:page] = @medium_pages.current.next
        if !type.blank?
          @pagination_params[:type] = type
          @pagination_prev_url[:type] = type
          @pagination_next_url[:type] = type
        end
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to media_path
    else
      rendering_main = !request.xhr? || (@media.nil? && @pictures.nil? && @videos.nil?) # && @documents.nil?
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
      end
      if request.xhr?
        render :update do |page|
          if rendering_main
            page.replace_html 'primary', :partial => 'media/main'
          else
            if @medium_pages.nil?
              page.replace_html 'secondary', :partial => 'media/index'
              page.replace_html('navigation', :partial => partial) if !element_id.blank?
            else
              page.replace_html 'secondary', :partial => 'media/paged_index'
            end
            page.call 'tb_remove'
            page.call 'tb_init', 'a.thickbox, area.thickbox, input.thickbox'
          end
        end
      else
        respond_to do |format|
          format.html # index.rhtml
          format.xml  { render :xml => @media.to_xml }
        end
      end
    end
  end

  # GET /media/1
  # GET /media/1.xml
  def show
    @medium = Medium.find(params[:id])    
    if request.xhr?
      render :partial => 'show'
    else      
      @pictures = Picture.find(:all, :order => 'RAND()', :limit => Medium::COLS * Medium::PREVIEW_ROWS)
      @videos = Video.find(:all, :order => 'RAND()', :limit => 1)
      #@documents = Document.find(:all, :order => 'RAND()', :limit => 1)
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
    @photographers = Person.find(:all, :order => 'fullname')
    @quality_types = QualityType.find(:all, :order => 'id')
    @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
    @recording_orientations = RecordingOrientation.find(:all, :order => 'title')
    @medium = Medium.find(params[:id])
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
          @photographers = Person.find(:all, :order => 'fullname')
          @quality_types = QualityType.find(:all, :order => 'id')
          @capture_device_models = CaptureDeviceMaker.find(:all, :order => 'title').collect{|maker| maker.capture_device_models}.flatten
          @recording_orientations = RecordingOrientation.find(:all, :order => 'title')          
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
end