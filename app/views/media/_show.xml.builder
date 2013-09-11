xml.__send__(medium.class.name.underscore.dasherize) do
  xml.id(medium.id)
  photographer = medium.photographer
  xml.photographer(:fullname => photographer.fullname, :id => photographer.id) if !photographer.nil?
  xml << render(:partial => 'titles/index', :locals => {:titles => medium.titles})
  xml << render(:partial => 'captions/index', :locals => {:captions => medium.captions})
  xml << render(:partial => 'descriptions/index', :locals => {:descriptions => medium.descriptions})
  xml << render(:partial => 'copyrights/index', :locals => {:copyrights => medium.copyrights})
  xml.associated_categories(:type => 'array') do
    medium.topics.each { |category| xml.associated_category(:title => category.title, :id => category.id) }
  end
  xml.associated_features(:type => 'array') do
    medium.features.reject(&:nil?).each { |feature| xml.associated_feature(:title => feature.header, :fid => feature.fid) }
  end
  attachment = medium.attachment
  if !attachment.nil?
    server = "#{request.protocol}#{request.host_with_port}"
    relative_url = ActionController::Base.relative_url_root
    server << relative_url if !relative_url.blank?
    xml << render(:partial => 'documents/typescript', :locals => {:server => server, :typescript => attachment}) if attachment.instance_of? Typescript
    xml.images(:type => 'array') do
      attachment.children.each{ |child| xml << render(:partial => 'pictures/image', :locals => {:server => server, :image => child}) if !child.filename.blank? }
    end
  end
end