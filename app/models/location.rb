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

class Location < ActiveRecord::Base
  attr_accessible :medium_id, :feature_id, :spot_feature, :notes, :lat, :lng
  validates_presence_of :medium_id, :feature_id
  belongs_to :medium
    
  def self.find_all_by_medium(medium)
    medium.locations
  end
  
  def feature
    Place.find(self.feature_id)
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