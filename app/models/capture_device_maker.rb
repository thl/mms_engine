class CaptureDeviceMaker < ActiveRecord::Base
  has_many :capture_device_models, :dependent => :destroy, :order => 'title'
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: capture_device_makers
#
#  id         :integer(4)      not null, primary key
#  exif_tag   :string(255)
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime