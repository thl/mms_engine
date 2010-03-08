class Subject < Category
  headers['Host'] = Category.headers['Host'] if !Category.headers['Host'].blank?
  
  self.element_name = 'category'
  include Tree

  def self.root_id
    272
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
    'subject'
  end
  
  def self.next_level_name
    'subsubject'
  end
  
  def self.anchor_name
    'subjects'
  end
end