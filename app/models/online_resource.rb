# == Schema Information
#
# Table name: media
#
#  id                       :integer          not null, primary key
#  photographer_id          :integer
#  quality_type_id          :integer
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(20)       not null
#  attachment_id            :integer
#  taken_on                 :datetime
#  recording_orientation_id :integer
#  capture_device_model_id  :integer
#  partial_taken_on         :string(255)
#  application_filter_id    :integer          not null
#  resource_type_id         :integer          not null
#  rotation                 :integer
#

class OnlineResource < Medium
  before_create  { |record| record.resource_type_id = 2677 if record.resource_type_id.nil? }
  
  has_one :web_address
    
  def self.maker_title
    'Web admin'
  end
  
  def self.caption_title
    'Title'
  end
  
  def prioritized_title
    titles = self.titles.order(:id)
    return titles.empty? ? (self.web_address.nil? ? self.id : self.web_address.url) : titles.first.title
  end
  
  def attachment
    nil
  end
end
