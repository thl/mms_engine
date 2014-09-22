# == Schema Information
#
# Table name: captions
#
#  id                  :integer          not null, primary key
#  title               :text             default(""), not null
#  description_type_id :integer
#  creator_id          :integer
#  language_id         :integer
#  created_on          :datetime
#  updated_on          :datetime
#

class Caption < ActiveRecord::Base
  before_destroy { |record| record.media.clear }
  
  validates_presence_of :title
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
  belongs_to :description_type
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  has_and_belongs_to_many :media  
end