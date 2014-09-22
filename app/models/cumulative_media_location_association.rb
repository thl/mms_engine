# == Schema Information
#
# Table name: cumulative_media_location_associations
#
#  id         :integer          not null, primary key
#  medium_id  :integer          not null
#  feature_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class CumulativeMediaLocationAssociation < ActiveRecord::Base
  #attr_accessible :feature_id, :medium_id
  
  belongs_to :medium
  
  private
  
  def self.delete_cumulative_information(feature, medium_id, type)
    while !feature.nil? && CumulativeMediaLocationAssociation.where(:feature_id => feature.children.collect(&:id), :medium_id => medium_id).count==0
      CumulativeMediaLocationAssociation.delete_all(:feature_id => feature.id.to_i, :medium_id => medium_id)
      #CachedCategoryCount.updated_count(category.id.to_i, nil, true).count
      #CachedCategoryCount.updated_count(category.id.to_i, type, true).count
      feature = feature.parent
    end
  end
end
