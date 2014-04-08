xml.instruct!
xml.topic do
  if !@pictures.nil? || !@videos.nil? || !@documents.nil?
    xml.pictures(:type => 'array') do
      for medium in @pictures
        xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => medium})
      end
    end
    xml.videos(:type => 'array') do
      for medium in @videos
        xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => medium})
      end
    end
    xml.documents(:type => 'array') do
      for medium in @documents
        xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => medium})
      end
    end
  elsif !@media.nil?
    xml.media(:type => 'array') do
      for medium in @media
        xml << render(:partial => 'media/show.xml.builder', :locals => {:medium => medium})
      end
    end
  end
end