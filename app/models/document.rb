class Document < Medium
  include MediaProcessor::DocumentExtension
  # The preview is generated in the highest possible resolution.  
  PREVIEW_TYPE = :huge
  belongs_to :typescript, :foreign_key => 'attachment_id'
  
  def attachment
    typescript
  end
  
  def before_create
    super
    self.resource_type_id = 2639 if self.resource_type_id.nil?
  end
  
  def before_destroy
    super
    typescript.destroy if !typescript.nil?
  end
  
  def self.public_folder
    'typescripts'
  end
  
  def prioritized_title
    titles = self.titles.find(:all, :order => :id)
    return titles.empty? ? self.id.to_s : titles.first.title
  end
  
  def preview_image
    typescript = self.typescript
    return typescript.nil? ? nil : typescript.children.first(:conditions => {:thumbnail => PREVIEW_TYPE.to_s})
  end
    
  def self.paged_media_search(media_search, limit = 10, offset = 0)
    super(media_search, limit, offset, 'Document')
  end
end

# == Schema Info
# Schema version: 20110319012021
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