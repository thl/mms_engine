# == Schema Information
#
# Table name: statuses
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  description :text
#  position    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Status < ActiveRecord::Base
  validates_presence_of :title, :position
  has_many :media, :through => :workflows
end