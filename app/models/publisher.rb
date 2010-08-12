class Publisher < ActiveRecord::Base
  validates_presence_of :title
  has_many :media_publishers
end

# == Schema Information
#
# Table name: publishers
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)     not null
#  place_id   :integer(4)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

