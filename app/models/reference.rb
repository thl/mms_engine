# == Schema Info
# Schema version: 20100310060934
#
# Table name: media
#
#  id                       :integer(4)      not null, primary key
#  attachment_id            :integer(4)
#  capture_device_model_id  :integer(4)
#  photographer_id          :integer(4)
#  quality_type_id          :integer(4)
#  recording_orientation_id :integer(4)
#  private_note             :text
#  recording_note           :text
#  type                     :string(10)      not null
#  created_on               :datetime
#  partial_taken_on         :string(255)
#  taken_on                 :datetime
#  updated_on               :datetime

class Reference < Medium
end
