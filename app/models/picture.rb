class Picture < Medium
  validates_presence_of :attachment_id
  include MediaProcessor::PictureExtension
  belongs_to :image, :foreign_key => 'attachment_id'
  
  def attachment
    image
  end
  
  def before_destroy
    super
    image.destroy
  end
  
  def screen_size_image
    att = image
    return nil if att.nil?
    img = att.children.find(:first, :conditions => {:thumbnail => 'essay'})
    img = image.children.find(:first, :conditions => {:thumbnail => 'normal'}) if img.nil?
    return img
  end
    
  def large_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'large'})
  end
  
  def huge_image
    att = attachment
    return nil if att.nil?
    att.children.find(:first, :conditions => {:thumbnail => 'huge'})
  end
  
  def self.public_folder
    'images'
  end
  
  def after_create
    super
    update_from_image_properties
  end
end

# == Schema Info
# Schema version: 20100707151911
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
#  private_note             :text
#  recording_note           :text
#  type                     :string(10)      not null
#  created_on               :datetime
#  partial_taken_on         :string(255)
#  taken_on                 :datetime
#  updated_on               :datetime