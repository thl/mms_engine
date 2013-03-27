# == Schema Information
#
# Table name: metadata_sources
#
#  id         :integer          not null, primary key
#  filename   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class MetadataSource < ActiveRecord::Base
  attr_accessible :creator_id, :filename
  has_and_belongs_to_many :creators, :class_name => 'AuthenticatedSystem::Person', :association_foreign_key => 'creator_id', :join_table => 'creators_metadata_sources'
end
