# == Schema Information
#
# Table name: media_keyword_associations
#
#  id         :integer          not null, primary key
#  medium_id  :integer          not null
#  keyword_id :integer          not null
#

class MediaKeywordAssociation < ActiveRecord::Base
  validates_presence_of :medium_id, :keyword_id
  belongs_to  :medium
  belongs_to  :keyword
end