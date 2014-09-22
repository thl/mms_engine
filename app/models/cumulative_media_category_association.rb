# == Schema Information
#
# Table name: cumulative_media_category_associations
#
#  id          :integer          not null, primary key
#  medium_id   :integer          not null
#  category_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class CumulativeMediaCategoryAssociation < ActiveRecord::Base
  #attr_accessible :category_id, :medium_id
  
  belongs_to :medium
  #belongs_to :category
end