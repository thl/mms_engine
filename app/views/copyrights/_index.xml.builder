if !copyrights.empty?
  for copyright in copyrights
    xml.copyright_holder(copyright.copyright_holder.title, :reproduction_type => copyright.reproduction_type.title)
  end
end