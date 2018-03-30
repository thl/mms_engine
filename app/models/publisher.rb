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
  validates_presence_of :title
  has_many :media_publishers, dependent: :nullify

  def country
    self.country_id.nil? ? nil : Place.find(self.country_id)
  end
end