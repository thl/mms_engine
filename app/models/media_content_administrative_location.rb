class MediaContentAdministrativeLocation < Location
end

# == Schema Info
# Schema version: 20100714204209
#
# Table name: locations
#
#  id           :integer(4)      not null, primary key
#  feature_id   :integer(4)      not null
#  medium_id    :integer(4)      not null
#  notes        :text
#  spot_feature :text
#  type         :string(50)