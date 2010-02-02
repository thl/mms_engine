administrative_unit = administrative_units.shift
xml.place(:type => h(administrative_unit.administrative_level.title)) do
  xml << h(administrative_unit.title)
  if !administrative_units.empty?
    xml << render(:partial => 'administrative_units/nested_show', :locals => {:administrative_units => administrative_units})
  end
end