class Status < ActiveRecord::Base
  validates_presence_of :title, :position
  has_many :media, :through => :workflows 
end

# == Schema Information
#
# Table name: statuses
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)     not null
#  description :text
#  order       :integer(4)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

