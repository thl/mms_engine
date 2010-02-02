# == Schema Information
# Schema version: 20090626173648
#
# Table name: sponsors
#
#  id    :integer(4)      not null, primary key
#  title :string(250)     not null
#

class Sponsor < ActiveRecord::Base
 validates_presence_of :title
 has_many :affiliations
end
