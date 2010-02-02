xml.__send__(@controller_name.singularize.to_sym, {:id => element.id, :parent_id => element.parent_id, :creator_id => element.creator_id}) do
  xml.title(element.title, :lang => 'eng')
  xml.title(element.title_dz, :lang => 'dzo')
  xml.description(element.description)
  xml.created_on(element.created_on)
  xml.order(element.order)
  if include_children
    xml.children do
      xml << render(:partial => 'main/hierarchy/admin/element', :collection => element.children, :locals => { :include_children => false } )
    end
  end
end