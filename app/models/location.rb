class Location < ActiveRecord::Base
  validates_presence_of :medium_id, :feature_id
  belongs_to :medium
  belongs_to :feature
    
  def self.find_all_by_medium(medium)
    medium.locations
  end  
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: locations
#
#  id                     :integer(4)      not null, primary key
#  administrative_unit_id :integer(4)      not null
#  medium_id              :integer(4)      not null
#  notes                  :text
#  spot_feature           :text
#  type                   :string(50)