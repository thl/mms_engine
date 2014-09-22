# == Schema Information
#
# Table name: capture_device_makers
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  exif_tag   :string(255)
#

class CaptureDeviceMaker < ActiveRecord::Base
  has_many :capture_device_models, -> { order 'title' }, dependent: :destroy
end