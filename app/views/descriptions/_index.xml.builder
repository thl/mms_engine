if !descriptions.empty?
  for description in descriptions
    hash = {:type => 'string'}
    description_type = description.description_type
    hash[:description_type] = description_type.title if !description_type.nil?
    lang = description.language
    hash['xml:lang'] = lang.code if !lang.nil?
    xml.description(description.title, hash)
  end
end