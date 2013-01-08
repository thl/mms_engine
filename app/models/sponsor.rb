class Sponsor < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :affiliations
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: sponsors
#
#  id    :integer(4)      not null, primary key
#  title :string(250)     not null