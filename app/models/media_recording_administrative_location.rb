class MediaRecordingAdministrativeLocation < Location
end

# == Schema Info
# Schema version: 20101209175910
#
# Table name: locations
#
#  id           :integer(4)      not null, primary key
#  feature_id   :integer(4)      not null
#  medium_id    :integer(4)      not null
#  lat          :decimal(9, 6)
#  lng          :decimal(9, 6)
#  notes        :text
#  spot_feature :text
#  type         :string(50)