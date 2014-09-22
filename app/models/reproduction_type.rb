# == Schema Information
#
# Table name: reproduction_types
#
#  id      :integer          not null, primary key
#  title   :string(255)      not null
#  website :string(255)
#  order   :integer          default(0), not null
#

class ReproductionType < ActiveRecord::Base
  validates_presence_of :title
  has_many :copyrights
end