class Project < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :affiliations
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: projects
#
#  id    :integer(4)      not null, primary key
#  title :string(250)     not null