# == Schema Information
#
# Table name: citations
#
#  id             :integer          not null, primary key
#  reference_id   :integer          not null
#  reference_type :string(255)      not null
#  creator_id     :integer
#  medium_id      :integer
#  page_number    :integer
#  page_side      :string(5)
#  line_number    :integer
#  note           :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Citation < ActiveRecord::Base
  validates_presence_of :reference_id, :reference_type
  belongs_to :medium
  belongs_to :reference, :polymorphic =>true
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
end