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

class Picture < Medium
  include MediaProcessor::PictureExtension
  
  validates_presence_of :attachment_id
  
  acts_as_indexable uid_prefix: MmsIntegration::MediaManagementResource.service, scope: {asset_type: self.name.downcase, service: MmsIntegration::Medium.service}
  
  before_create  { |record| record.resource_type_id = 2660 if record.resource_type_id.nil? }
  before_destroy { |record| record.image.destroy if !record.image.nil? }
  after_create   { |record| record.update_from_image_properties }
  
  belongs_to :image, :foreign_key => 'attachment_id', dependent: :destroy
  has_one :iiif_image
  
  def attachment
    image
  end
  
  def thumbnail_image
    i_img = self.iiif_image
    if i_img.nil?
      super
    else
      "#{i_img.api_url}/square/95,95/0/default.jpg"
    end
  end
  
  def screen_size_image
    i_img = self.iiif_image
    if i_img.nil?
      super
    else
      "#{i_img.api_url}/full/^!500,500/0/default.jpg"
    end
  end
  
  def large_image
    i_img = self.iiif_image
    if i_img.nil?
      super
    else
      "#{i_img.api_url}/full/^!800,700/0/default.jpg"
    end
  end

  def huge_image
    i_img = self.iiif_image
    if i_img.nil?
      super
    else
      "#{i_img.api_url}/full/^!2000,2000/0/default.jpg"
    end
  end
  
  def self.public_folder
    'images'
  end
end