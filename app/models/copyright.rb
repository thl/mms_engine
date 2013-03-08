# == Schema Information
#
# Table name: copyrights
#
#  id                   :integer          not null, primary key
#  medium_id            :integer          not null
#  copyright_holder_id  :integer          not null
#  reproduction_type_id :integer          not null
#  notes                :text
#

class Copyright < ActiveRecord::Base
  attr_accessible :medium_id, :copyright_holder_id, :reproduction_type_id, :notes
  belongs_to :medium
  belongs_to :copyright_holder
  belongs_to :reproduction_type
end