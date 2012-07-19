class Citation < ActiveRecord::Base
  validates_presence_of :reference_id, :reference_type
  belongs_to :medium
  belongs_to :reference, :polymorphic =>true
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: citations
#
#  id             :integer(4)      not null, primary key
#  creator_id     :integer(4)
#  medium_id      :integer(4)
#  reference_id   :integer(4)      not null
#  line_number    :integer(4)
#  note           :text
#  page_number    :integer(4)
#  page_side      :string(5)
#  reference_type :string(255)     not null
#  created_at     :datetime
#  updated_at     :datetime