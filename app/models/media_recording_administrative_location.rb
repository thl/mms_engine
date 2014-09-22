# == Schema Information
#
# Table name: locations
#
#  id           :integer          not null, primary key
#  medium_id    :integer          not null
#  spot_feature :text
#  notes        :text
#  type         :string(50)
#  feature_id   :integer          not null
#  lat          :decimal(9, 6)
#  lng          :decimal(9, 6)
#

class MediaRecordingAdministrativeLocation < Location
end