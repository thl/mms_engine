# == Schema Information
# Schema version: 20090626173648
#
# Table name: media_administrative_locations
#
#  id                     :integer(4)      not null, primary key
#  medium_id              :integer(4)      not null
#  administrative_unit_id :integer(4)      not null
#  spot_feature           :text
#  notes                  :text
#  type                   :string(50)
#

class MediaRecordingAdministrativeLocation < MediaAdministrativeLocation
end
