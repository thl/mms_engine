class Status < ActiveRecord::Base
  validates_presence_of :title, :position
  has_many :media, :through => :workflows 
end

# == Schema Info
# Schema version: 20110228181402
#
# Table name: statuses
#
#  id          :integer(4)      not null, primary key
#  description :text
#  position    :integer(4)      not null
#  title       :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime