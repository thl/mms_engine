class OnlineResource < Medium
  attr_accessible :recording_note, :resource_type_id, :taken_on, :capture_device_model_id,
    :quality_type_id, :private_note, :web_address_attributes
    
  before_create  { |record| record.resource_type_id = 2677 if record.resource_type_id.nil? }
  
  has_one :web_address
  accepts_nested_attributes_for :web_address
    
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
end
