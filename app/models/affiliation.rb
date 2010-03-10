# == Schema Info
# Schema version: 20100310060934
#
# Table name: affiliations
#
#  id              :integer(4)      not null, primary key
#  medium_id       :integer(4)      not null
#  organization_id :integer(4)      not null
#  project_id      :integer(4)
#  sponsor_id      :integer(4)

class Affiliation < ActiveRecord::Base
 belongs_to :medium
 belongs_to :sponsor
 belongs_to :organization
 belongs_to :project
end
