# == Schema Information
#
# Table name: metadata_sources
#
#  id         :integer          not null, primary key
#  creator_id :integer
#  filename   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MetadataSource < ActiveRecord::Base
  attr_accessible :creator_id, :filename
  belongs_to :creator, :class_name => 'AuthenticatedSystem::Person', :foreign_key => 'creator_id'
end
