xml.__send__(controller_name.to_sym) do
  xml << render(:partial => 'main/hierarchy/admin/element', :collection => @elements, :locals => {:include_children => false}) 
end