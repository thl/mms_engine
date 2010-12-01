class MediaEthnicityAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media
  
  def initialize
    super
    @model = Ethnicity
  end
  
  private
  
  def elements_url
    ethnicities_url
  end
  
  def association_url(association)
    medium_ethnicity_association_url(@medium, association)
  end
end