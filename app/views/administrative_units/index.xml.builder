xml.__send__("#{@country.title.downcase}_#{@controller_name}".to_sym) do
  xml.title(@country.title, :lang => 'eng')
  xml.title(@country.title_dz, :lang => 'dzo')
  xml.__send__(@administrative_level.title.downcase.pluralize.to_sym) do
    xml << render(:partial => 'element', :collection => @elements, :locals => {:include_children => false, :include_parents => false}) 
  end
end