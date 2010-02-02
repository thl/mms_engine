# == Schema Information
# Schema version: 20090626173648
#
# Table name: capture_device_models
#
#  id                      :integer(4)      not null, primary key
#  capture_device_maker_id :integer(4)
#  title                   :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  exif_tag                :string(255)
#

class CaptureDeviceModel < ActiveRecord::Base
  belongs_to :capture_device_maker
  has_many :media
end
