xml.captions(:type => 'array') do
  if !captions.empty?
    for caption in captions
      hash = {:id => caption.id}
      lang = caption.language
      hash['lang'] = lang.code if !lang.nil?
      xml.caption(hash) do
        xml.title(caption.title, :type => 'string')
        caption_type = caption.description_type
        xml.caption_type(:id => caption_type.id, :title => caption_type.title) if !caption_type.nil?
      end
    end
  end
end