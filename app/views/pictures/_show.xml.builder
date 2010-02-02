xml.picture do
  server = "#{request.protocol}#{request.host_with_port}"
  photographer = picture.photographer
  xml.photographer(photographer.fullname, :id => photographer.id) if !photographer.nil?
  image = picture.thumbnail_image
  xml.url("#{server}#{image.public_filename}", :type => 'thumb') if !image.nil?
  image = picture.screen_size_image
  xml.url("#{server}#{image.public_filename}", :type => 'normal') if !image.nil?
  image = picture.large_image
  xml.url("#{server}#{image.public_filename}", :type => 'large') if !image.nil?
  image = picture.huge_image
  xml.url("#{server}#{image.public_filename}", :type => 'huge') if !image.nil?
  for caption in picture.captions
    hash = Hash.new
    caption_type = caption.description_type
    hash[:caption_type] = caption_type.title if !caption_type.nil?
    lang = caption.language
    hash['xml:lang'] = lang.code if !lang.nil?
    xml.caption(caption.title, hash)
  end
  units = picture.administrative_units
  if !units.empty?
    xml.locations do
      for unit in units
        xml.place(:type => 'Country') do
          xml << h(unit.administrative_level.country.title)
          xml << render(:partial => 'administrative_units/nested_show', :locals => {:administrative_units => unit.ascendants})
        end
      end
    end
  end
  copyrights = picture.copyrights
  if !copyrights.empty?
    xml.copyrights do
      for copyright in copyrights
        xml.copyright_holder(copyright.copyright_holder.title, :reproduction_type => copyright.reproduction_type.title)
      end
    end
  end
end