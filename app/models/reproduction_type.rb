class ReproductionType < ActiveRecord::Base
  validates_presence_of :title
  has_many :copyrights
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: reproduction_types
#
#  id      :integer(4)      not null, primary key
#  order   :integer(4)      not null, default(0)
#  title   :string(255)     not null
#  website :string(255)