class MediaEthnicityAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media
  
  def initialize
    super
    @model = Ethnicity
  end
  # GET /media_ethnicity_associations
  # GET /media_ethnicity_associations.xml
   def index
     super
   end

  # GET /media_ethnicity_associations/1
  # GET /media_ethnicity_associations/1.xml
  def show
    super
  end

  # GET /media_ethnicity_associations/new
  def new
    super
  end

  # GET /media_ethnicity_associations/1;edit
  def edit
    super
  end

  # POST /media_ethnicity_associations
  # POST /media_ethnicity_associations.xml
  def create
    super
  end

  # PUT /media_ethnicity_associations/1
  # PUT /media_ethnicity_associations/1.xml
  def update
    super
  end

  # DELETE /media_ethnicity_associations/1
  # DELETE /media_ethnicity_associations/1.xml
  def destroy
    super
  end
  
  private
  
  def elements_url
    ethnicities_url
  end
  
  def association_url(association)
    medium_ethnicity_association_url(@medium, association)
  end
end