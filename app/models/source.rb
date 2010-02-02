# == Schema Information
# Schema version: 20090626173648
#
# Table name: sources
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  has_many :media_source_associations
  has_many :media, :through => :media_source_associations
end
