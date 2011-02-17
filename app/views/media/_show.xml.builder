xml.__send__(medium.class.name.underscore.dasherize) do
  xml.id(medium.id)
  photographer = medium.photographer
  xml.photographer(photographer.fullname, :id => photographer.id, :type => 'string') if !photographer.nil?
  xml << render(:partial => 'titles/index', :locals => {:titles => medium.titles})
  xml << render(:partial => 'captions/index', :locals => {:captions => medium.captions})
  xml << render(:partial => 'descriptions/index', :locals => {:descriptions => medium.descriptions})
  xml << render(:partial => 'copyrights/index', :locals => {:copyrights => medium.copyrights})
  medium.topics.each { |category| xml.associated_category(category.title, :id => category.id, :type => 'string') }
  medium.features.each { |feature| xml.associated_feature(feature.header, :fid => feature.fid, :type => 'string') }
  attachment = medium.attachment
  if !attachment.nil?
    server = "#{request.protocol}#{request.host_with_port}"
    relative_url = ActionController::Base.relative_url_root
    debugger
    server << relative_url if !relative_url.blank?
    attachment.children.each{ |child| xml.url("#{server}#{child.public_filename}", :thumbnail => child.thumbnail, :width => child.width, :height => child.height) }
  end
end