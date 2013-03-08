# == Schema Information
#
# Table name: recording_orientations
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class RecordingOrientation < ActiveRecord::Base
  attr_accessible :title
  has_many :media, :dependent => :nullify
end