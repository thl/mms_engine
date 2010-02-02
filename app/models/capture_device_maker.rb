# == Schema Information
# Schema version: 20090626173648
#
# Table name: capture_device_makers
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  exif_tag   :string(255)
#

class CaptureDeviceMaker < ActiveRecord::Base
  has_many :capture_device_models, :dependent => :destroy, :order => 'title'
end
