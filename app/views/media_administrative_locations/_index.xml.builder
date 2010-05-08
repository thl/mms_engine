if !administrative_units.empty?
  for unit in administrative_units
    xml.place(:type => 'Country') do
      xml << h(unit.administrative_level.country.title)
      xml << render(:partial => 'administrative_units/nested_show', :locals => {:administrative_units => unit.ascendants})
    end
  end
end
