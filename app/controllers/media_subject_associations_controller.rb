class MediaSubjectAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media

  def initialize
    super
    @model = Subject
  end
  
  # GET /media_subject_associations
  # GET /media_subject_associations.xml
  def index
    super
  end

  # GET /media_subject_associations/1
  # GET /media_subject_associations/1.xml
  def show
    super
  end

  # GET /media_subject_associations/new
  def new
    super
  end

  # GET /media_subject_associations/1;edit
  def edit
    super
  end

  # POST /media_subject_associations
  # POST /media_subject_associations.xml
  def create
    super
  end

  # PUT /media_subject_associations/1
  # PUT /media_subject_associations/1.xml
  def update
    super
  end

  # DELETE /media_subject_associations/1
  # DELETE /media_subject_associations/1.xml
  def destroy
    super
  end
  
  private
  
  def elements_url
    subjects_url
  end
  
  def association_url(association)
    medium_subject_association_url(@medium, association)
  end
end