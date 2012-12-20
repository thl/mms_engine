class MediaCategoryAssociation < ActiveRecord::Base
  attr_accessible :root_id, :category_id, :medium_id
  
  before_destroy { |record| Rails.cache.delete('topics/roots_with_media') if Rails.cache.exist?('topics/roots_with_media') && Topic.roots_with_media.collect(&:id).include?(record.root_id) }
  after_destroy  { |record| MediaCategoryAssociation.delete_cumulative_information(record.category, record.medium_id, record.medium.class.name) }
  before_save    { |record| MediaCategoryAssociation.delete_cumulative_information(Category.find(record.category_id_was), record.medium_id_was, record.medium.class.name) if record.changed? && !record.category_id_was.nil? }
  after_save    do |record|
    current = record.category
    while !current.nil? && CumulativeMediaCategoryAssociation.where(:category_id => current.id, :medium_id => medium_id).first.nil?
      CumulativeMediaCategoryAssociation.create(:category_id => current.id, :medium_id => self.medium_id)
      current = current.parent
    end
    Rails.cache.delete('media_category_associations/max_updated_at')
    Rails.cache.delete('topics/roots_with_media') if Rails.cache.exist?('topics/roots_with_media') && !Topic.roots_with_media.collect(&:id).include?(record.root_id)
  end
  
  validates_presence_of :category_id, :medium_id
  # belongs_to :category, :class_name => 'Topic'
  belongs_to :medium
  # belongs_to :root, :class_name => 'Topic'
  
  def category
    Topic.find(self.category_id)
  end
  
  def root
    Topic.find(self.root_id)
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
    while !category.nil? && CumulativeMediaCategoryAssociation.where(:category_id => category.children.collect(&:id), :medium_id => medium_id).count==0
      CumulativeMediaCategoryAssociation.delete_all(:category_id => category.id.to_i, :medium_id => medium_id)
      CachedCategoryCount.updated_count(category.id.to_i, nil, true).count
      CachedCategoryCount.updated_count(category.id.to_i, type, true).count
      category = category.parent
    end
  end
end

# == Schema Info
# Schema version: 20110412155958
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