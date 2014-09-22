# == Schema Information
#
# Table name: media_source_associations
#
#  id          :integer          not null, primary key
#  medium_id   :integer          not null
#  source_id   :integer          not null
#  shot_number :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class MediaSourceAssociation < ActiveRecord::Base
  belongs_to :medium
  belongs_to :source
end