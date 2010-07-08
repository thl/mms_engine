class Copyright < ActiveRecord::Base
  belongs_to :medium
  belongs_to :copyright_holder
  belongs_to :reproduction_type
end

# == Schema Info
# Schema version: 20100707151911
#
# Table name: copyrights
#
#  id                   :integer(4)      not null, primary key
#  copyright_holder_id  :integer(4)      not null
#  medium_id            :integer(4)      not null
#  reproduction_type_id :integer(4)      not null
#  notes                :text