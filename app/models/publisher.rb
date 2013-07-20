# == Schema Information
#
# Table name: publishers
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  place_id   :integer
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Publisher < ActiveRecord::Base
  attr_accessible :title, :country_id
  validates_presence_of :title
  has_many :media_publishers
  belongs_to :country, :class_name => 'Place'
end