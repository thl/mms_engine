module MediaCollectionAssociationsHelper
  def associations_path
    medium_collection_associations_path(@medium)
  end
  
  def edit_association_path(association)
    edit_medium_collection_association_path(@medium, association)
  end

  def new_association_path
    new_medium_collection_association_path(@medium)
  end
  
  def association_path(association)
    medium_collection_association_path(@medium, association)
  end
  
  def element_path(element)
    medium_collection_path(@medium, element)
  end
  
  def stylesheet_files
    uses_thickbox? ? super + ['thickbox', 'category_selector'] : super
  end
  
  def javascript_files
    uses_thickbox? ? super + ['thickbox-compressed', 'category_selector'] : super
  end
  
  private
  
  def uses_thickbox?
    ['new', 'edit'].include? params[:action]
  end
end
