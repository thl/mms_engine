# == Schema Info
# Schema version: 20100310060934
#
# Table name: typescripts
#
#  id                :integer(4)      not null, primary key
#  parent_id         :integer(4)
#  transformation_id :integer(4)
#  content_type      :string(255)
#  filename          :string(255)
#  height            :integer(4)
#  size              :integer(4)
#  thumbnail         :string(10)
#  width             :integer(4)

class Typescript < ActiveRecord::Base
  VALID_TYPES = {'pdf' => 'application/pdf', 'gif' => 'image/gif', 'jpe' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'jpg' => 'image/jpeg', 'pjpeg' => 'image/pjpeg', 'png' => 'image/png', 'bmp' => 'image/bmp', 'cgm' => 'image/cgm', 'fpx' => 'image/vnd.fpx', 'pbm' => 'image/x-portable-bitmap', 'pgm' => 'image/x-portable-graymap', 'pict' => 'image/x-pict', 'pnm' => 'image/x-portable-anymap', 'ppm' => 'image/x-portable-pixmap', 'rgb' => 'image/x-rgb', 'tiff' => 'image/tif', 'tif' => 'image/tiff', 'xbm' => 'image/x-xbitmap', 'raf' => 'image/x-fuji-raf', 'crw' => 'image/x-canon-crw', 'dcr' => 'image/x-kodak-dcr', 'mrw' => 'image/x-minolta-mrw', 'orf' => 'image/x-olympus-orf', 'x3f' => 'image/x-sigma-x3f'}
  has_attachment :storage => :file_system, :processor => :rmagick, :max_size => 100.megabytes, :content_type => VALID_TYPES.collect {|key, value| value} 
  acts_as_tree
  validates_as_attachment
  has_one :document, :foreign_key => 'attachment_id'
  belongs_to :transformation
end
