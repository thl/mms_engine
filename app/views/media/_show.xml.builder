klass = medium.class
class_name = klass.name
xml.__send__(class_name.underscore.dasherize) do
  xml.id(medium.id, :type => 'integer')
  xml.type(class_name)
  photographer = medium.photographer
  xml.photographer(:fullname => photographer.fullname, :id => photographer.id) if !photographer.nil?
  xml << render(:partial => 'titles/index.xml.builder', :locals => {:titles => medium.titles})
  xml << render(:partial => 'captions/index.xml.builder', :locals => {:captions => medium.captions})
  xml << render(:partial => 'descriptions/index.xml.builder', :locals => {:descriptions => medium.descriptions})
  xml << render(:partial => 'copyrights/index.xml.builder', :locals => {:copyrights => medium.copyrights})
  xml << render(:partial => 'locations/index.xml.builder', :locals => {:locations => medium.locations})
  xml.associated_categories(:type => 'array') do
    medium.media_category_associations.each { |association| xml.associated_category(:id => association.category_id) }
  end
  xml.associated_features(:type => 'array') do
    medium.locations.each { |location| xml.associated_feature(:fid => location.feature_id) }
  end
  attachment = medium.attachment
  if !attachment.nil?
    server = "#{request.protocol}#{request.host_with_port}"
    relative_url = ActionController::Base.relative_url_root
    server << relative_url if !relative_url.blank?
    xml << render(:partial => 'documents/typescript.xml.builder', :locals => {:server => server, :typescript => attachment}) if attachment.instance_of? Typescript
    xml.images(:type => 'array') do
      attachment.children.each{ |child| xml << render(:partial => 'pictures/image.xml.builder', :locals => {:server => server, :image => child}) if !child.filename.blank? }
    end
  end
  if klass == OnlineResource
    web_address = medium.web_address
    xml << render(:partial => 'online_resources/show.xml.builder', :locals => {:web_address => web_address}) if !web_address.nil?
  end
end