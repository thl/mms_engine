# == Schema Information
#
# Table name: workflows
#
#  id                   :integer          not null, primary key
#  medium_id            :integer          not null
#  original_filename    :string(255)
#  original_medium_id   :text             default(""), not null
#  other_id             :string(255)
#  notes                :string(255)
#  sequence_order       :integer
#  created_at           :datetime
#  updated_at           :datetime
#  status_id            :integer
#  processing_status_id :integer
#  metadata_source_id   :integer
#  original_path        :text
#

class Workflow < ActiveRecord::Base
  attr_accessible :medium_id, :original_filename, :status_id, :original_medium_id, :metadata_source_id
  belongs_to :medium
  belongs_to :status
  belongs_to :processing_status
  belongs_to :metadata_source
end
