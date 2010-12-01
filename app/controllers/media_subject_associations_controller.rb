class MediaSubjectAssociationsController < AclController
  before_filter :find_medium
  include MediaAssociation
  helper :media

  def initialize
    super
    @model = Subject
  end
    
  private
  
  def elements_url
    subjects_url
  end
  
  def association_url(association)
    medium_subject_association_url(@medium, association)
  end
end