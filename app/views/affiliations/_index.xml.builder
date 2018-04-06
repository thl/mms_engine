xml.affiliations(:type => 'array') do
  for affiliation in affiliations
    xml.id(affiliation.id, type: 'integer')
    sponsor = affiliation.sponsor
    xml.sponsor(id: sponsor.id, title: sponsor.title) if !sponsor.nil?
    organization = affiliation.organization
    xml.organization(id: organization.id, title: organization.title, website: organization.website) if !organization.nil?
    project = affiliation.project
    xml.project(id: project.id, title: project.title) if !project.nil?
  end
end