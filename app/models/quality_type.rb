# == Schema Information
# Schema version: 20090626173648
#
# Table name: quality_types
#
#  id    :integer(4)      not null, primary key
#  title :string(10)      not null
#

class QualityType < ActiveRecord::Base
  has_many :media
end
