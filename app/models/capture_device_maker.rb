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
  attr_accessible :title, :exif_tag
  has_many :capture_device_models, :dependent => :destroy, :order => 'title'
end