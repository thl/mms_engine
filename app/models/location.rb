class Location < ActiveRecord::Base
  attr_accessible :medium_id, :feature_id, :spot_feature, :notes, :lat, :lng
  validates_presence_of :medium_id, :feature_id
  belongs_to :medium
    
  def self.find_all_by_medium(medium)
    medium.locations
  end
  
  def feature
    Feature.find(self.feature_id)
  end
  
  def coordinates
    if self.lat.nil? && self.lng.nil?
      return nil
    else
      s = ''
      if !self.lat.nil?
        s << "Latitude: #{self.lat}"
        s << '; ' if !self.lng.nil?
      end
      s << "Longitude: #{self.lng}" if !self.lng.nil?
      return s
    end
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