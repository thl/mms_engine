# == Schema Information
# Schema version: 20090626173648
#
# Table name: recording_orientations
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RecordingOrientation < ActiveRecord::Base
  has_many :media, :dependent => :nullify
end
