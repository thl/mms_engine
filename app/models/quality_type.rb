class QualityType < ActiveRecord::Base
  has_many :media
end

# == Schema Info
# Schema version: 20110319012021
#
# Table name: quality_types
#
#  id    :integer(4)      not null, primary key
#  title :string(10)      not null