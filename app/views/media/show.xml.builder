if @medium.class == Picture
  xml.instruct!
  xml << render(:partial => 'pictures/show', :locals => {:picture => @medium})
else
  xml << @medium.to_xml
end
