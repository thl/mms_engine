class Workflow < ActiveRecord::Base
  attr_accessible :medium_id, :original_filename, :status_id
  belongs_to :medium
  belongs_to :status
  belongs_to :processing_status
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: workflows
#
#  id                   :integer(4)      not null, primary key
#  medium_id            :integer(4)      not null
#  original_medium_id   :text            not null, default("")
#  other_id             :string(255)
#  processing_status_id :integer(4)
#  status_id            :integer(4)
#  notes                :string(255)
#  original_filename    :string(255)
#  sequence_order       :integer(4)
#  created_at           :datetime
#  updated_at           :datetime