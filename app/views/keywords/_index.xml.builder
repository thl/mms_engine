xml.keywords(:type => 'array') do
  for keyword in keywords
    xml.keyword(id: keyword.id, title: keyword.title)
  end
end