# == Schema Information
# Schema version: 20090626173648
#
# Table name: reproduction_types
#
#  id      :integer(4)      not null, primary key
#  title   :string(255)     not null
#  website :string(255)
#  order   :integer(4)      default(0), not null
#

class ReproductionType < ActiveRecord::Base
  validates_presence_of :title
  has_many :copyrights
end
