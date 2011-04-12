class MediaPublisher < ActiveRecord::Base
  belongs_to :medium
  belongs_to :publisher
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: media_publishers
#
#  id           :integer(4)      not null, primary key
#  medium_id    :integer(4)
#  publisher_id :integer(4)
#  date         :date
#  created_at   :datetime
#  updated_at   :datetime