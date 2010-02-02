class Collection < Category
  self.element_name = 'category'
  include Tree
  # self.extend Tree::ClassMethods
  
  def self.root_id
    2823
  end
  
  def self.root
    return @@root if defined? @@root
    if defined? self.root_id
      @@root = find(self.root_id)
    else
      @@root = find(:first)
    end
  end

  def self.level_name
    'collection'
  end

  def self.next_level_name
    'subcollection'
  end
  
  def self.anchor_name
    'collections'
  end
end