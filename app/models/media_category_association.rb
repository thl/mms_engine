class MediaCategoryAssociation < ActiveRecord::Base
  validates_presence_of :category_id, :medium_id
  belongs_to :category, :class_name => 'Topic'
  belongs_to :medium
  belongs_to :root, :class_name => 'Topic'
  
  def before_destroy
    Rails.cache.delete('topics/roots_with_media') if Rails.cache.exist?('topics/roots_with_media') && Topic.roots_with_media.collect(&:id).include?(self.root_id)
  end
  
  def after_destroy
    MediaCategoryAssociation.delete_cumulative_information(self.category, self.medium_id, self.medium.class.name)
  end
  
  def before_save
    MediaCategoryAssociation.delete_cumulative_information(Category.find(category_id_was), self.medium_id_was, self.medium.class.name) if self.changed? && !category_id_was.nil?
  end
  
  def after_save
    current = self.category
    while !current.nil? && CumulativeMediaCategoryAssociation.find(:first, :conditions => {:category_id => current.id, :medium_id => medium_id}).nil?
      CumulativeMediaCategoryAssociation.create(:category => current, :medium_id => self.medium_id)
      current = current.parent
    end
    Rails.cache.delete('media_category_associations/max_updated_at')
    Rails.cache.delete('topics/roots_with_media') if Rails.cache.exist?('topics/roots_with_media') && !Topic.roots_with_media.collect(&:id).include?(self.root_id)
  end
  
  def title_with_value
    s = self.category.title
    if self.string_value.blank?
      if !self.numeric_value.nil?
        s += ": #{self.numeric_value}"
      end
    else
      if self.numeric_value.nil?
        s += ": #{self.string_value}"
      else
        s += " (#{self.string_value}: #{self.numeric_value})"
      end
    end
    return s
  end
  
  def self.latest_update
    Rails.cache.fetch('media_category_associations/max_updated_at') { self.maximum(:updated_at) }
  end
    
  private
  
  def self.delete_cumulative_information(category, medium_id, type)
    while !category.nil? && CumulativeMediaCategoryAssociation.count(:conditions => {:category_id => category.children.collect(&:id), :medium_id => medium_id})==0
      CumulativeMediaCategoryAssociation.delete_all(:category_id => category.id.to_i, :medium_id => medium_id)
      CachedCategoryCount.updated_count(category.id.to_i, nil, true).count
      CachedCategoryCount.updated_count(category.id.to_i, type, true).count
      category = category.parent
    end
  end
end

# == Schema Info
# Schema version: 20110228181402
#
# Table name: media_category_associations
#
#  id            :integer(4)      not null, primary key
#  category_id   :integer(4)      not null
#  medium_id     :integer(4)      not null
#  root_id       :integer(4)      not null
#  numeric_value :integer(4)
#  string_value  :string(255)
#  created_at    :datetime
#  updated_at    :datetime