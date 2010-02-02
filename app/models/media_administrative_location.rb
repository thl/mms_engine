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
