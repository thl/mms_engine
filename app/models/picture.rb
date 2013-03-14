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
#  type                     :string(10)       not null
#  attachment_id            :integer
#  taken_on                 :datetime
#  recording_orientation_id :integer
#  capture_device_model_id  :integer
#  partial_taken_on         :string(255)
#  application_filter_id    :integer          not null
#  resource_type_id         :integer          not null
#  rotation                 :integer
#

class Picture < Medium
  attr_accessible :image, :recording_note, :resource_type_id, :photographer_id, :taken_on, :capture_device_model_id,
    :quality_type_id, :private_note, :rotation
  
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
