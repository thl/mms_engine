if !captions.empty?
  for caption in captions
    hash = Hash.new
    caption_type = caption.description_type
    hash[:caption_type] = caption_type.title if !caption_type.nil?
    lang = caption.language
    hash['xml:lang'] = lang.code if !lang.nil?
    xml.caption(caption.title, hash)
  end
end