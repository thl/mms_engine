klass = medium.class
class_name = klass.name
xml.__send__(class_name.underscore.dasherize) do
  xml.id(medium.id, type: 'integer')
  xml.type(class_name)
  photographer = medium.photographer
  xml.photographer(fullname: photographer.fullname, id: photographer.id) if !photographer.nil?
  resource_type = medium.resource_type
  xml.resource_type(id: resource_type.id, header: resource_type.header) if !resource_type.nil?
  if medium.partial_taken_on.blank?
    xml.taken_on(medium.taken_on, type: 'timestamp') if !medium.taken_on.nil?
  else
    xml.taken_on(medium.partial_taken_on, type: 'string')
  end
  quality_type = medium.quality_type
  xml.quality_type(id: quality_type.id, title: quality_type.title) if !quality_type.nil?
  xml.recording_note(medium.recording_note)
  xml.private_note(medium.private_note)
  xml.rotation(medium.rotation)
  recording_orientation = medium.recording_orientation
  xml.recording_orientation(id: recording_orientation.id, title: recording_orientation.title) if !recording_orientation.nil?
  capture_device_model = medium.capture_device_model
  if !capture_device_model.nil?
    attrs = { model_id: capture_device_model.id, model_title: capture_device_model.title, model_exif_tag: capture_device_model.exif_tag }
    device_maker = capture_device_model.capture_device_maker
    attrs.merge!({ maker_id: device_maker.id, maker_title: device_maker.title, exif_tag: device_maker.exif_tag }) if !device_maker.nil?
    xml.capture_device(attrs)
  end
  media_publisher = medium.media_publisher
  xml << render(partial: 'publishers/show.xml.builder', locals: {publisher: media_publisher.publisher}) if !media_publisher.nil?
  xml << render(partial: 'titles/index.xml.builder', locals: {titles: medium.titles})
  xml << render(partial: 'captions/index.xml.builder', locals: {captions: medium.captions})
  xml << render(partial: 'descriptions/index.xml.builder', locals: {descriptions: medium.descriptions})
  xml << render(partial: 'copyrights/index.xml.builder', locals: {copyrights: medium.copyrights})
  xml << render(partial: 'locations/index.xml.builder', locals: {locations: medium.locations})
  xml << render(partial: 'keywords/index.xml.builder', locals: {keywords: medium.keywords})
  xml << render(partial: 'affiliations/index.xml.builder', locals: {affiliations: medium.affiliations})
  workflow = medium.workflow
  xml << render(partial: 'workflows/show.xml.builder', locals: {workflow: workflow}) if !workflow.nil?
  xml.associated_categories(type: 'array') do
    medium.media_category_associations.each { |association| xml.associated_category(id: association.category_id, root_id: association.root_id, string_value: association.string_value, numeric_value: association.numeric_value) }
  end
  attachment = medium.attachment
  if !attachment.nil?
    server = "#{request.protocol}#{request.host_with_port}"
    relative_url = ActionController::Base.relative_url_root
    server << relative_url if !relative_url.blank?
    xml << render(partial: 'documents/typescript.xml.builder', locals: {server: server, typescript: attachment}) if attachment.instance_of? Typescript
    xml.images(type: 'array') do
      attachment.children.each{ |child| xml << render(partial: 'pictures/image.xml.builder', locals: {server: server, image: child}) if !child.filename.blank? }
    end
  end
  if klass == OnlineResource
    web_address = medium.web_address
    xml << render(partial: 'online_resources/show.xml.builder', locals: {web_address: web_address}) if !web_address.nil?
  end
end