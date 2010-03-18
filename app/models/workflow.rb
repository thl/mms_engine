# == Schema Info
# Schema version: 20100310060934
#
# Table name: workflows
#
#  id                 :integer(4)      not null, primary key
#  medium_id          :integer(4)      not null
#  original_medium_id :string(255)
#  other_id           :string(255)
#  notes              :string(255)
#  original_filename  :string(255)     not null
#  sequence_order     :integer(4)
#  created_at         :datetime
#  updated_at         :datetime

class Workflow < ActiveRecord::Base
  belongs_to :medium
  belongs_to :status
end
