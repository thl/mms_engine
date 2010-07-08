class CopyrightHolder < ActiveRecord::Base
  validates_presence_of :title
  has_many :copyrights
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: copyright_holders
#
#  id      :integer(4)      not null, primary key
#  title   :string(250)     not null
#  website :string(255)