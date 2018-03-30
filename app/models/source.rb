# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  has_many :media_source_associations, dependent: :destroy
  has_many :media, through: :media_source_associations
end