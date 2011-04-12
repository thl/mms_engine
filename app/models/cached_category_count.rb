class CachedCategoryCount < ActiveRecord::Base
  belongs_to :category
  
  def self.cached_count(category_id, type = nil)
    CachedCategoryCount.find(:first, :conditions => {:category_id => category_id, :medium_type => type})
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
      cached_count.count = CumulativeMediaCategoryAssociation.count(:conditions => {:category_id => category_id})
    else
      cached_count.count = CumulativeMediaCategoryAssociation.count(:conditions => {'cumulative_media_category_associations.category_id' => category_id, 'media.type' => type}, :joins => :medium)
    end
    cached_count.save
    return cached_count
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: cached_category_counts
#
#  id               :integer(4)      not null, primary key
#  category_id      :integer(4)      not null
#  count            :integer(4)      not null
#  medium_type      :string(255)
#  cache_updated_at :datetime        not null
#  created_at       :datetime
#  updated_at       :datetime