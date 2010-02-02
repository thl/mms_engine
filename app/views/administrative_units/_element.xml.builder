attributes = {:id => element.id, :creator_id => element.creator_id}
attributes[:parent_id] = element.parent_id if include_parents
xml.__send__(element.level_name.downcase.to_sym, attributes) do
  xml.title(element.title, :lang => 'eng')
  xml.title(element.title_dz, :lang => 'dzo')
  xml.description(element.description)
  xml.created_on(element.created_on)
  xml.order(element.order)
  if include_children
    xml.children do
      xml << render(:partial => 'element', :collection => element.children, :locals => { :include_children => false, :include_parents => true } )
    end
  end
end