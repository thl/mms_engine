class Sponsor < ActiveRecord::Base
 validates_presence_of :title
 has_many :affiliations
end

# == Schema Info
# Schema version: 20110228181402
#
# Table name: sponsors
#
#  id    :integer(4)      not null, primary key
#  title :string(250)     not null