# == Schema Information
# Schema version: 20090626173648
#
# Table name: media
#
#  id                       :integer(4)      not null, primary key
#  photographer_id          :integer(4)
#  quality_type_id          :integer(4)
#  created_on               :datetime
#  updated_on               :datetime
#  recording_note           :text
#  private_note             :text
#  type                     :string(10)      not null
#  attachment_id            :integer(4)      not null
#  taken_on                 :datetime
#  recording_orientation_id :integer(4)
#  capture_device_model_id  :integer(4)
#  partial_taken_on         :string(255)
#

class Document < Medium
  belongs_to :typescript, :foreign_key => 'attachment_id'
  
  def attachment
    typescript
  end
  
  def before_destroy
    super
    typescript.destroy
  end
    
  def self.public_folder
    'typescripts'
  end
end
