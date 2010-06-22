module MediaSubjectAssociationsHelper
  def associations_path
    medium_subject_associations_path(@medium)
  end
  
  def edit_association_path(association)
    edit_medium_subject_association_path(@medium, association)
  end

  def new_association_path
    new_medium_subject_association_path(@medium)
  end
  
  def association_path(association)
    medium_subject_association_path(@medium, association)
  end
  
  def element_path(element)
    medium_subject_path(@medium, element)
  end
  
  def stylesheet_files
    uses_kmaps_integration? ? super + ['jquery.autocomplete', 'jquery.checktree', 'jquery.draggable.popup'] : super
  end
  
  def javascript_files
    uses_kmaps_integration? ? super + ['jquery.autocomplete', 'jquery.checktree', 'model-searcher', 'jquery.draggable.popup'] : super
  end
  
  private
  
  def uses_kmaps_integration?
    ['new', 'edit'].include? params[:action]
  end
end