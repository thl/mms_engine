module MediaCategoryAssociationsHelper
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
