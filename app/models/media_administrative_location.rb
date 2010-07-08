class MediaAdministrativeLocation < ActiveRecord::Base
  validates_presence_of :medium_id, :administrative_unit_id
  belongs_to :medium
  belongs_to :administrative_unit
  
  def element
    administrative_unit
  end  

  def self.find_all_by_medium(medium)
    medium.media_administrative_locations
  end  
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