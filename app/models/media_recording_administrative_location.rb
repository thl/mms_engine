class MediaRecordingAdministrativeLocation < MediaAdministrativeLocation
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: media_administrative_locations
#
#  id                     :integer(4)      not null, primary key
#  administrative_unit_id :integer(4)      not null
#  medium_id              :integer(4)      not null
#  notes                  :text
#  spot_feature           :text
#  type                   :string(50)