xml.__send__(medium.class.name.underscore.dasherize) do
  xml.id(medium.id)
  photographer = medium.photographer
  xml.photographer(photographer.fullname, :id => photographer.id, :type => 'string') if !photographer.nil?
  xml << render(:partial => 'titles/index', :locals => {:titles => medium.titles})
  xml << render(:partial => 'captions/index', :locals => {:captions => medium.captions})
  # xml << render(:partial => 'locations/index', :locals => {:locations => medium.locations})
  xml << render(:partial => 'copyrights/index', :locals => {:copyrights => medium.copyrights})
  case medium.class
  when Picture
    xml << render(:partial => 'pictures/show', :locals => {:picture => medium})
  end  
end