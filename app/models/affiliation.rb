# == Schema Information
#
# Table name: affiliations
#
#  id              :integer          not null, primary key
#  medium_id       :integer          not null
#  sponsor_id      :integer
#  organization_id :integer          not null
#  project_id      :integer
#

class Affiliation < ActiveRecord::Base
  attr_accessible :medium_id, :organization_id, :project_id, :sponsor_id
  belongs_to :medium
  belongs_to :sponsor
  belongs_to :organization
  belongs_to :project
end