class MediaCategoryAssociationsController < AclController
  cache_sweeper :media_category_association_sweeper, :only => [:create, :update, :destroy]
  before_filter :find_medium_and_topic
  helper :media
  
  # GET /media_category_associations
  # GET /media_category_associations.xml
  def index
    if @medium.nil?
      @media_category_associations = MediaCategoryAssociation.all(:limit => 10, :conditions => {:root_id => @topic.id})
    else
      @media_category_associations = @topic.nil? ? @medium.media_category_associations : @medium.media_category_associations.find(:all, :conditions => {:root_id => @topic.id})
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @media_category_associations }
    end
  end

  # GET /media_category_associations/1
  # GET /media_category_associations/1.xml
  def show
    @media_category_association = MediaCategoryAssociation.find(params[:id])
    if @medium != @media_category_association.medium
      redirect_to association_url(@media_category_association.medium, @media_category_association.root, @media_category_association)
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @media_category_association }
      end
    end
  end

  # GET /media_category_associations/new
  # GET /media_category_associations/new.xml
  def new
    @media_category_association = MediaCategoryAssociation.new(:root => @topic)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_category_association }
    end
  end

  # GET /media_category_associations/1/edit
  def edit
    @media_category_association = MediaCategoryAssociation.find(params[:id])
    if @medium != @media_category_association.medium
      redirect_to edit_association_url(@media_category_association.medium, @media_category_association.root, @media_category_association)
    else
      respond_to do |format|
        format.html # edit.html.erb
      end
    end
    
  end

  # POST /media_category_associations
  # POST /media_category_associations.xml
  def create
    mca_hash = params[:media_category_association]
    mca_cats = mca_hash[:category_id].split(',')
    errors = []
    mca_cats.each do |c|
      unless c.blank?
        c = c.to_i
        mca_hash_temp = mca_hash
        mca_hash_temp[:category_id] = c
        mca_hash_temp[:root_id] = Topic.find(c).root.id
        @media_category_association = @medium.media_category_associations.build(mca_hash_temp)
        begin
          @media_category_association.save
        rescue ActiveRecord::StatementInvalid
          # ignore duplicate issues. how to add ignore parameter to sql query here without changing to sql completely?
        else
         #errors.push( @media_category_association.errors )
        end
      end
    end
    #puts "ez: #{errors}"
    respond_to do |format|
      unless errors.length > 0
        flash[:notice] = 'MediaCategoryAssociation was successfully created.'
        format.html { redirect_to edit_medium_url(@medium, :anchor => "topics-#{@media_category_association.root_id}") }
        format.xml  { render :xml => @media_category_association, :status => :created, :location => @media_category_association }
      else
        flash[:notice] = errors.join(', ')
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_category_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_category_associations/1
  # PUT /media_category_associations/1.xml
  def update
    @media_category_association = MediaCategoryAssociation.find(params[:id])
    media_category_association_hash = params[:media_category_association]
    media_category_association_hash[:root_id] = Topic.find(media_category_association_hash[:category_id]).root.id
    respond_to do |format|
      if @media_category_association.update_attributes(media_category_association_hash)
        flash[:notice] = 'MediaCategoryAssociation was successfully updated.'
        format.html { redirect_to edit_medium_url(@medium, :anchor => "topics-#{@media_category_association.root_id}") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_category_association.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_category_associations/1
  # DELETE /media_category_associations/1.xml
  def destroy
    @media_category_association = MediaCategoryAssociation.find(params[:id])
    root_id = @media_category_association.root_id
    @media_category_association.destroy
    respond_to do |format|
      format.html { redirect_to edit_medium_url(@medium, :anchor => "topics-#{root_id}") }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_medium_and_topic
    medium_id = params[:medium_id]
    @medium = medium_id.blank? ? nil : Medium.find(medium_id)
    category_id = params[:topic_id]
    @topic = category_id.blank? ? nil : Topic.find(category_id)
  end
end
