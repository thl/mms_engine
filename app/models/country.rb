# == Schema Info
# Schema version: 20100310060934
#
# Table name: countries
#
#  id    :integer(4)      not null, primary key
#  title :string(100)     not null

class Country < ActiveRecord::Base
  translates :title
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :administrative_levels, :order => 'level'
  
  def administrative_units_with_ancestors
    # stack = AdministrativeUnit.find(:all, :include => {:administrative_level => :country}, :conditions => {:parent_id => nil}, :order => 'countries.title DESC, administrative_units.title DESC' )
    administrative_level = self.administrative_levels.first
    stack = AdministrativeUnit.find(:all, :conditions => {:parent_id => nil, :administrative_level_id => administrative_level}, :order => 'title DESC')
    result = []
    while !stack.empty?
      child = stack.pop
      result << [child.full_lineage(10), child.id]
      child.children.find(:all, :order => 'title DESC').each {|c| stack.push c }
    end
    result
  end
  
  def valid_administrative_units_with_ancestors
    if @valid_administrative_units_with_ancestors.nil?
      # stack = AdministrativeUnit.find(:all, :include => {:administrative_level => :country}, :conditions => {:parent_id => nil}, :order => 'countries.title DESC, administrative_units.title DESC' )
      administrative_level = self.administrative_levels.first
      stack = AdministrativeUnit.find(:all, :conditions => {:parent_id => nil, :administrative_level_id => administrative_level, :is_problematic => false}, :order => 'title DESC')
      result = []
      while !stack.empty?
        child = stack.pop
        result << [child.full_lineage(20), child.id]
        child.children.find(:all, :conditions => {:is_problematic => false}, :order => 'title DESC').each {|c| stack.push c }
      end
      @valid_administrative_units_with_ancestors = result
    end
    return @valid_administrative_units_with_ancestors
  end
  
end
