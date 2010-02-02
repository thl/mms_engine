# == Schema Information
# Schema version: 20090626173648
#
# Table name: organizations
#
#  id      :integer(4)      not null, primary key
#  title   :string(250)     not null
#  website :string(255)
#

class Organization < ActiveRecord::Base
 validates_presence_of :title
 has_many :affiliations
 has_many :glossaries
end
