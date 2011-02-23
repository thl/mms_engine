xml.__send__(medium.class.name.underscore.dasherize) do
  xml.id(medium.id)
  photographer = medium.photographer
  xml.photographer(:fullname => photographer.fullname, :id => photographer.id) if !photographer.nil?
  xml << render(:partial => 'titles/index', :locals => {:titles => medium.titles})
  xml << render(:partial => 'captions/index', :locals => {:captions => medium.captions})
  xml << render(:partial => 'descriptions/index', :locals => {:descriptions => medium.descriptions})
  xml << render(:partial => 'copyrights/index', :locals => {:copyrights => medium.copyrights})
  medium.topics.each { |category| xml.associated_category(:title => category.title, :id => category.id) }
  medium.features.each { |feature| xml.associated_feature(:title => feature.header, :fid => feature.fid) }
  attachment = medium.attachment
  if !attachment.nil?
    server = "#{request.protocol}#{request.host_with_port}"
    relative_url = ActionController::Base.relative_url_root
    server << relative_url if !relative_url.blank?
    xml << render(:partial => 'documents/typescript', :locals => {:server => server, :typescript => attachment}) if attachment.instance_of? Typescript
    attachment.children.each{ |child| xml << render(:partial => 'pictures/image', :locals => {:server => server, :image => child}) }
  end
end