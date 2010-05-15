xml.instruct!
xml.documents(:type => 'array') do
  for document in @documents
    xml << render(:partial => 'media/show', :locals => {:medium => document})
  end
end