# == Schema Information
# Schema version: 20090626173648
#
# Table name: media_source_associations
#
#  id          :integer(4)      not null, primary key
#  medium_id   :integer(4)      not null
#  source_id   :integer(4)      not null
#  shot_number :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class MediaSourceAssociation < ActiveRecord::Base
  belongs_to :medium
  belongs_to :source
end
