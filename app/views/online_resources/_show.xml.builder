xml.web_address do
  xml.url(web_address.url)
  xml.parent_resource_id(web_address.parent_resource_id, :type => 'integer')
end