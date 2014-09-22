# == Schema Information
#
# Table name: typescripts
#
#  id                :integer          not null, primary key
#  content_type      :string(255)
#  filename          :string(255)
#  size              :integer
#  parent_id         :integer
#  thumbnail         :string(10)
#  width             :integer
#  height            :integer
#  transformation_id :integer
#

class Typescript < ActiveRecord::Base  
  VALID_TYPES = {'pdf' => 'application/pdf', 'gif' => 'image/gif', 'jpe' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'jpg' => 'image/jpeg', 'pjpeg' => 'image/pjpeg', 'png' => 'image/png', 'bmp' => 'image/bmp', 'cgm' => 'image/cgm', 'fpx' => 'image/vnd.fpx', 'pbm' => 'image/x-portable-bitmap', 'pgm' => 'image/x-portable-graymap', 'pict' => 'image/x-pict', 'pnm' => 'image/x-portable-anymap', 'ppm' => 'image/x-portable-pixmap', 'rgb' => 'image/x-rgb', 'tiff' => 'image/tif', 'tif' => 'image/tiff', 'xbm' => 'image/x-xbitmap', 'raf' => 'image/x-fuji-raf', 'crw' => 'image/x-canon-crw', 'dcr' => 'image/x-kodak-dcr', 'mrw' => 'image/x-minolta-mrw', 'orf' => 'image/x-olympus-orf', 'x3f' => 'image/x-sigma-x3f'}
  has_attachment :storage => :file_system, :processor => :rmagick, :max_size => 500.megabytes, :content_type => VALID_TYPES.collect {|key, value| value} 
  acts_as_tree
  validates_as_attachment
  has_one :document, :foreign_key => 'attachment_id'
  belongs_to :transformation
end