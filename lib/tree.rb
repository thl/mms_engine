module Tree
  def descendants
    Rails.cache.fetch("#{self.class.element_name}-#{self.id}/descendants") do
      children_to_be_processed = [self]
      all_children = Array.new
      while !children_to_be_processed.empty?
        child = children_to_be_processed.shift
        all_children.push child.id.to_i
        children_to_be_processed.concat(child.children)
      end
      all_children
    end
  end

  def full_lineage(size = nil)
    Rails.cache.fetch("#{self.class.element_name}-#{self.id}/full_lineage") do
      if (size==nil)
        lineage = (ancestors.reverse << self).collect{|e| e.title }
      else 
        lineage = (ancestors.reverse << self).collect do |e| 
          title = e.title
          chars = title.mb_chars
          chars.size>size ? "#{chars[0...size].to_s}..." : title
        end
      end
      lineage.join(' > ')
    end
  end
  
  def count_inherited_media(type = nil)
    Rails.cache.fetch("#{self.class.element_name}-#{self.id}/count_inherited_media") { CachedCategoryCount.updated_count(self.id.to_i, type).count }
  end

  def permalink
    Rails.cache.fetch("#{self.class.element_name}-#{self.id}/permalink") do
      association = registered_theme_association
      association.nil? ? nil : association.permalink
    end
  end
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id}, :joins => :cumulative_media_category_associations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :cumulative_media_category_associations, :limit => limit, :offset => offset, :order => 'created_on DESC')
    end
    media
  end
  
  def count_media(type = nil)
    if type.nil?
      count = Medium.count(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id}, :joins => :cumulative_media_category_associations, :select => 'media.id')
    else
      count = Medium.count(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :cumulative_media_category_associations, :select => 'media.id')
    end
    count
  end
  
  def media(type = nil)
    if type.nil?
      media = Medium.find(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id}, :joins => :cumulative_media_category_associations, :order => 'created_on DESC')
    else
      media = Medium.find(:all, :conditions => {'cumulative_media_category_associations.category_id' => self.id, 'media.type' => type}, :joins => :cumulative_media_category_associations, :order => 'created_on DESC')
    end
    media
  end
end