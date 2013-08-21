xml.copyrights(:type => 'array') do
  if !copyrights.empty?
    for copyright in copyrights
      xml.copyright(:id => copyright.id) do
        copyright_holder = copyright.copyright_holder
        xml.copyright_holder(:id => copyright_holder.id, :title => copyright_holder.title, :website => copyright_holder.website)
        reproduction_type = copyright.reproduction_type
        xml.reproduction_type(:id => reproduction_type.id, :title => reproduction_type.title, :website => reproduction_type.website)
      end
    end
  end
end