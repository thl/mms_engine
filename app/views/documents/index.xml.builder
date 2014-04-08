xml.instruct!
xml.documents(:type => 'array') do
  for document in @documents
    xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => document})
  end
end