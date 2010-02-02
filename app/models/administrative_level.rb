# == Schema Information
# Schema version: 20090626173648
#
# Table name: administrative_levels
#
#  id         :integer(4)      not null, primary key
#  title      :string(100)     not null
#  country_id :integer(4)      not null
#  level      :integer(4)      not null
#

class AdministrativeLevel < ActiveRecord::Base
  validates_presence_of :country_id, :level, :title
  validates_numericality_of :level, :only_integer => true
  belongs_to :country
  has_many :administrative_units, :order => '`order`, title', :dependent => :destroy
  
  def next_level
    AdministrativeLevel.find(:first, :conditions => {:country_id => country_id, :level => level + 1} )
  end
  
  def administrative_units_with_ancestors
    self.administrative_units.find(:all, :order => 'parent_id, title').collect{|unit| [unit.full_lineage(20), unit.id]}
  end
end
