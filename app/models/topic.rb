class Topic < Category
  headers['Host'] = TopicalMapResource.headers['Host'] if !TopicalMapResource.headers['Host'].blank?
  
  self.element_name = 'category'
  
  def is_childless?
    # making sure expand link does not show up when children don't have media
    self.children_count.to_i==0 || self.children.detect{|element| element.media_count > 0}.nil?
  	# return true if children_count? && children_count == '0' or !children_count? && children.empty? # 'or' should be lower precedence than '&&'
  	# return false
  end
  
  def media_category_associations
    MediaCategoryAssociation.where(:category_id => self.id)
  end
  
  def paged_media(limit, offset = nil, type = nil)
    if type.nil?
      media = Medium.where('cumulative_media_category_associations.category_id' => self.id).joins(:cumulative_media_category_associations).limit(limit).offset(offset).order('media.created_on DESC')
    else
      media = Medium.where('cumulative_media_category_associations.category_id' => self.id, 'media.type' => type).joins(:cumulative_media_category_associations).limit(limit).offset(offset).order('media.created_on DESC')
    end
    media
  end
  
  def media(options = {})
    type = options[:type]
    joins = options[:cumulative].nil? || options[:cumulative] ? :cumulative_media_category_associations : :media_category_associations
    conditions = {"#{joins.to_s}.category_id" => self.id}
    conditions['media.type'] = type if !type.nil?
    Medium.where(conditions).joins(joins).order('media.created_on DESC')
  end
    
  def media_count(type = nil, force_update = false)
    CachedCategoryCount.updated_count(self.id, type, force_update).count
  end
  
  def self.roots_with_media
    Rails.cache.fetch('topics/roots_with_media', :expires_in => 1.day) { self.roots.select{ |topic| topic.media_count>0 } }
  end
  
  def ancestor_and_self_ids
    self.ancestors.collect{|c| c.id.to_i} + [self.id.to_i]
  end
  
  def full_lineage
    self.ancestors.collect(&:title).reverse.join(' > ')
  end

  alias count_inherited_media media_count
  # This helps with calls to count media for generalized elements
  # alias :media_count :count_inherited_media
end