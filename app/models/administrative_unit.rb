class AdministrativeUnit < ActiveRecord::Base
  include Tree  
  translates :title
  validates_presence_of :administrative_level_id, :title
  belongs_to :administrative_level
  #belongs_to :parentUnit, :class_name => 'AdministrativeUnit', :foreign_key => 'parent_administrative_unit_id'
  #has_many :childrenUnits, :class_name => 'AdministrativeUnit', :foreign_key => 'parent_administrative_unit_id'
  acts_as_tree :order => '`order`, title'
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
  has_one :media_recording_administrative_location, :dependent => :destroy
  has_many :media_content_administrative_locations, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :media, :through => :locations

  def self.titles_with_ancestors
    stack = AdministrativeUnit.find(:all, :include => {:administrative_level => :country}, :conditions => {:parent_id => nil}, :order => 'countries.title DESC, administrative_units.title DESC' )
    result = []
    while !stack.empty?
      child = stack.pop
      result << [child.full_lineage(10), child.id]
      child.children.each {|c| stack.push c }
    end
    result
  end
  
  def full_lineage(size = nil)
    "#{administrative_level.country.title} > #{super}"
  end
  
  def before_destroy
    for unit in children
      unit.destroy
    end
  end
  
  def path
    if parent.nil?
      title
    else
      "#{parent.path} > #{title}"
    end
  end
  
  def count_inherited_media(type = nil)
    AdministrativeUnit.count_media(descendants, type)
  end
  
  def level_name
    administrative_level.title
  end
  
  def next_level_name
    nl = administrative_level.next_level
    if nl.nil?
      return nil
    else
      return nl.title
    end
  end
  
  def self.element_name
    'administrative_unit'
  end
  
  def paged_media(limit, offset = nil, type = nil)
    descendant_ids = self.descendants
    sql_statement = Medium.paged_media(descendant_ids, limit, offset, type)
    sql_statement[0] = "SELECT media.* FROM media, locations WHERE media.id = locations.medium_id AND locations.administrative_unit_id IN #{Util::interrogation_set descendant_ids.size} #{sql_statement[0]}"
    Medium.find_by_sql sql_statement
  end
  
  def self.count_media(descendant_ids, type = nil)
    sql_statement = Medium.count_media(descendant_ids, type)
    sql_statement[0] = "SELECT COUNT(*) FROM media, locations WHERE media.id = locations.medium_id AND locations.administrative_unit_id IN #{Util::interrogation_set descendant_ids.size} #{sql_statement[0]}"
    Medium.count_by_sql sql_statement
  end  
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: administrative_units
#
#  id                      :integer(4)      not null, primary key
#  administrative_level_id :integer(4)      not null
#  creator_id              :integer(4)
#  feature_id              :integer(4)
#  parent_id               :integer(4)
#  description             :text
#  is_problematic          :boolean(1)      not null
#  order                   :integer(4)
#  title                   :string(100)     not null
#  created_on              :datetime