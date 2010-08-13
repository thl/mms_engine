class MediaPublisher < ActiveRecord::Base
  belongs_to :medium
  belongs_to :publisher
end

# == Schema Information
#
# Table name: media_publishers
#
#  id           :integer(4)      not null, primary key
#  publisher_id :integer(4)
#  medium_id    :integer(4)
#  date         :date
#  created_at   :datetime
#  updated_at   :datetime
#

