xml.locations(:type => 'array') do
  for location in locations
    xml.location(location.feature_id)
  end
end