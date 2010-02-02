# == Schema Information
# Schema version: 20090626173648
#
# Table name: copyrights
#
#  id                   :integer(4)      not null, primary key
#  medium_id            :integer(4)      not null
#  copyright_holder_id  :integer(4)      not null
#  reproduction_type_id :integer(4)      not null
#  notes                :text
#

class Copyright < ActiveRecord::Base
  belongs_to :medium
  belongs_to :copyright_holder
  belongs_to :reproduction_type
end
