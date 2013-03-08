# == Schema Information
#
# Table name: description_types
#
#  id    :integer          not null, primary key
#  title :string(100)      not null
#

class DescriptionType < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :captions  
  has_many :descriptions
end