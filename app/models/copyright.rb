class Copyright < ActiveRecord::Base
  attr_accessible :medium_id, :copyright_holder_id, :reproduction_type_id, :notes
  belongs_to :medium
  belongs_to :copyright_holder
  belongs_to :reproduction_type
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: copyrights
#
#  id                   :integer(4)      not null, primary key
#  copyright_holder_id  :integer(4)      not null
#  medium_id            :integer(4)      not null
#  reproduction_type_id :integer(4)      not null
#  notes                :text