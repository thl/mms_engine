# == Schema Information
#
# Table name: capture_device_models
#
#  id                      :integer          not null, primary key
#  capture_device_maker_id :integer
#  title                   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  exif_tag                :string(255)
#

class CaptureDeviceModel < ActiveRecord::Base
  attr_accessible :capture_device_maker_id, :title, :exif_tag
  
  belongs_to :capture_device_maker
  has_many :media
end