# == Schema Information
#
# Table name: quality_types
#
#  id    :integer          not null, primary key
#  title :string(10)       not null
#

class QualityType < ActiveRecord::Base
  has_many :media
end