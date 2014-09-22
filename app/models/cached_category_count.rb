# == Schema Information
#
# Table name: cached_category_counts
#
#  id               :integer          not null, primary key
#  category_id      :integer          not null
#  medium_type      :string(255)
#  count            :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  cache_updated_at :datetime         not null
#

class CachedCategoryCount < ActiveRecord::Base
  #belongs_to :category
  #attr_accessible :medium_type, :cache_updated_at, :category_id
  
  def self.cached_count(category_id, type = nil)
    CachedCategoryCount.find_by(category_id: category_id, medium_type: type)
  end
  
  def self.updated_count(category_id, type = nil, force_update = false)
    cached_count = self.cached_count(category_id, type)
    latest_update = MediaCategoryAssociation.latest_update
    if cached_count.nil?
      cached_count = CachedCategoryCount.new(:category_id => category_id, :medium_type => type, :cache_updated_at => latest_update)
    else
      if force_update || cached_count.cache_updated_at < latest_update
        cached_count.cache_updated_at = latest_update
      else
        return cached_count
      end
    end
    if type.nil?
      cached_count.count = CumulativeMediaCategoryAssociation.where(:category_id => category_id).count
    else
      cached_count.count = CumulativeMediaCategoryAssociation.where('cumulative_media_category_associations.category_id' => category_id, 'media.type' => type).joins(:medium).count
    end
    cached_count.save
    return cached_count
  end
end