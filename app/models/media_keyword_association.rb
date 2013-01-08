class MediaKeywordAssociation < ActiveRecord::Base
  attr_accessible :keyword_id, :medium_id
  validates_presence_of :medium_id, :keyword_id
  belongs_to  :medium
  belongs_to  :keyword
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: media_keyword_associations
#
#  id         :integer(4)      not null, primary key
#  keyword_id :integer(4)      not null
#  medium_id  :integer(4)      not null