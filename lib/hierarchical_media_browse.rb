module HierarchicalMediaBrowse
  def index
    @elements = @model.root.children.select{|element| element.count_inherited_media > 0 }
    respond_to do |format|
      format.html { render :template => 'main/hierarchy/categories/index' }
    end
  end
  
  def show
    medium_id = params[:medium_id]
    @element = @model.find(params[:id])
    @medium = nil
    if !medium_id.blank?
      begin
        @medium = Medium.find(medium_id)
      rescue ActiveRecord::RecordNotFound
        @medium = nil
      end
    end
    if @medium.nil?
      @current = @element.ancestors.collect{|c| c.id.to_i}
      @current << @element.id.to_i
      @elements = @model.root.children.select{|element| element.count_inherited_media > 0 }
    end
    @pictures = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Picture')
    @videos = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Video')
    @documents = @element.paged_media(Medium::COLS * Medium::PREVIEW_ROWS, nil, 'Document')
    title = @element.title
    @titles = { :picture => ts(:in, :what => Picture.human_name(:count => :many).titleize, :where => title), :video => ts(:in, :what => Video.human_name(:count => :many).titleize, :where => title), :document => ts(:in, :what => Document.human_name(:count => :many).titleize, :where => title) }
    @more = { "#{@model.name.underscore}_id".to_sym => @element.id, :type => '' }    
    if request.xhr?
      render :update do |page|
        if @medium.nil?
          page.replace_html 'navigation', :partial => 'main/hierarchy/categories/category_index', :locals => {:elements => @elements, :margin_depth => 0}
        else
          page.replace_html 'primary', :partial => 'media/show'
        end
        page.replace_html 'secondary', :partial => 'main/hierarchy/categories/media_index'
        page.call 'tb_init', 'a.thickbox, area.thickbox, input.thickbox'
      end
    else
      respond_to { |format| format.html { render(:template => @medium.nil? ? 'main/hierarchy/categories/index' : 'main/hierarchy/categories/show_for_medium') } }
    end
  end
      
  def expand
    render :partial => 'main/hierarchy/categories/expanded', :object => @model.find(params[:id]), :locals => {:margin_depth => params[:margin_depth].to_i}
  end

  def contract
    render :partial => 'main/hierarchy/categories/contracted', :object => @model.find(params[:id]), :locals => {:margin_depth => params[:margin_depth].to_i}
  end  
end