class Picture < Medium
  attr_accessible :image, :recording_note
  
  include MediaProcessor::PictureExtension
  
  validates_presence_of :attachment_id
  
  before_create  { |record| record.resource_type_id = 2660 if record.resource_type_id.nil? }
  before_destroy { |record| record.image.destroy }
  after_create   { |record| record.update_from_image_properties }
  
  belongs_to :image, :foreign_key => 'attachment_id'
  
  def attachment
    image
  end
      
  def huge_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'huge'})
  end
  
  def self.public_folder
    'images'
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: media
#
#  id                       :integer(4)      not null, primary key
#  application_filter_id    :integer(4)      not null
#  attachment_id            :integer(4)
#  capture_device_model_id  :integer(4)
#  photographer_id          :integer(4)
#  quality_type_id          :integer(4)
#  recording_orientation_id :integer(4)
#  resource_type_id         :integer(4)      not null
#  private_note             :text
#  recording_note           :text
#  rotation                 :integer(4)
#  type                     :string(10)      not null
#  created_on               :datetime
#  partial_taken_on         :string(255)
#  taken_on                 :datetime
#  updated_on               :datetime