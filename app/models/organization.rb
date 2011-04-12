class Organization < ActiveRecord::Base
 validates_presence_of :title
 has_many :affiliations
 has_many :glossaries
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: organizations
#
#  id      :integer(4)      not null, primary key
#  title   :string(250)     not null
#  website :string(255)