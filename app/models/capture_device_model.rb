class CaptureDeviceModel < ActiveRecord::Base
  belongs_to :capture_device_maker
  has_many :media
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: capture_device_models
#
#  id                      :integer(4)      not null, primary key
#  capture_device_maker_id :integer(4)
#  exif_tag                :string(255)
#  title                   :string(255)
#  created_at              :datetime
#  updated_at              :datetime