# == Schema Information
# Schema version: 20090626173648
#
# Table name: copyright_holders
#
#  id      :integer(4)      not null, primary key
#  title   :string(250)     not null
#  website :string(255)
#

class CopyrightHolder < ActiveRecord::Base
  validates_presence_of :title
  has_many :copyrights
end
