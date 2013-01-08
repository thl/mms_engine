class Publisher < ActiveRecord::Base
  attr_accessible :title, :country_id
  validates_presence_of :title
  has_many :media_publishers
  belongs_to :country, :class_name => 'Feature'
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: publishers
#
#  id         :integer(4)      not null, primary key
#  country_id :integer(4)
#  place_id   :integer(4)
#  title      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime