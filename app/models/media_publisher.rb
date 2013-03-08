# == Schema Information
#
# Table name: media_publishers
#
#  id           :integer          not null, primary key
#  publisher_id :integer
#  medium_id    :integer
#  date         :date
#  created_at   :datetime
#  updated_at   :datetime
#

class MediaPublisher < ActiveRecord::Base
  attr_accessible :medium_id, :publisher_id, :date
  belongs_to :medium
  belongs_to :publisher
end