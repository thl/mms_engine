class Location < ActiveRecord::Base
  validates_presence_of :medium_id, :feature_id
  belongs_to :medium
  belongs_to :feature
    
  def self.find_all_by_medium(medium)
    medium.locations
  end  
end

# == Schema Info
# Schema version: 20110412155958
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