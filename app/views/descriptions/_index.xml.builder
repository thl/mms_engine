xml.descriptions(:type => 'array') do
  if !descriptions.empty?
    for description in descriptions
      hash = {:id => description.id}
      lang = description.language
      hash['lang'] = lang.code if !lang.nil?    
      xml.mms_description(hash) do
        xml.title(description.title, :type => 'string')
        description_type = description.description_type
        xml.description_type(:id => description_type.id, :title => description_type.title) if !description_type.nil?
      end
    end
  end
end