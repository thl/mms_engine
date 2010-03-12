class Citation < ActiveRecord::Base
  validates_presence_of :reference_id, :reference_type
  belongs_to :medium
  belongs_to :reference, :polymorphic =>true
  belongs_to :language, :class_name => 'ComplexScripts::Language'
  belongs_to :creator, :class_name => 'Person', :foreign_key => 'creator_id'
end

# == Schema Information
#
# Table name: citations
#
#  id             :integer(4)      not null, primary key
#  reference_id   :integer(4)      not null
#  reference_type :string(255)     not null
#  medium_id      :integer(4)
#  page_number    :integer(4)
#  page_side      :string(5)
#  line_number    :integer(4)
#  note           :text
#  created_at     :datetime
#  updated_at     :datetime
#

