class QualityType < ActiveRecord::Base
  has_many :media
end

# == Schema Info
# Schema version: 20100714204209
#
# Table name: quality_types
#
#  id    :integer(4)      not null, primary key
#  title :string(10)      not null