class Affiliation < ActiveRecord::Base
  attr_accessible :medium_id, :organization_id, :project_id, :sponsor_id
  belongs_to :medium
  belongs_to :sponsor
  belongs_to :organization
  belongs_to :project
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: affiliations
#
#  id              :integer(4)      not null, primary key
#  medium_id       :integer(4)      not null
#  organization_id :integer(4)      not null
#  project_id      :integer(4)
#  sponsor_id      :integer(4)