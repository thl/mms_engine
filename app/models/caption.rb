class Caption < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
  belongs_to :description_type
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  has_and_belongs_to_many :media
  
  def before_destroy
    media.clear
  end
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: captions
#
#  id                  :integer(4)      not null, primary key
#  creator_id          :integer(4)
#  description_type_id :integer(4)
#  language_id         :integer(4)
#  title               :text            not null, default("")
#  created_on          :datetime
#  updated_on          :datetime