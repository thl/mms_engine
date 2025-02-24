# == Schema Information
#
# Table name: images
#
#  id           :integer          not null, primary key
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer
#  parent_id    :integer
#  thumbnail    :string(255)
#  width        :integer
#  height       :integer
#

class Image < ActiveRecord::Base
  VALID_TYPES = {'gif' => 'image/gif', 'jpe' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'jpg' => 'image/jpeg', 'pjpeg' => 'image/pjpeg', 'png' => 'image/png', 'bmp' => 'image/bmp', 'cgm' => 'image/cgm', 'fpx' => 'image/vnd.fpx', 'pbm' => 'image/x-portable-bitmap', 'pgm' => 'image/x-portable-graymap', 'pict' => 'image/x-pict', 'pnm' => 'image/x-portable-anymap', 'ppm' => 'image/x-portable-pixmap', 'rgb' => 'image/x-rgb', 'tiff' => 'image/tif', 'tif' => 'image/tiff', 'xbm' => 'image/x-xbitmap', 'raf' => 'image/x-fuji-raf', 'cr2' => 'image/x-canon-cr2', 'crw' => 'image/x-canon-crw', 'dcr' => 'image/x-kodak-dcr', 'mrw' => 'image/x-minolta-mrw', 'nef' => 'image/x-nikon-nef', 'orf' => 'image/x-olympus-orf', 'dng' => 'image/x-adobe-dng', 'x3f' => 'image/x-sigma-x3f'}
  # 'art', 'avs', 'cin', 'cmyka', 'cur', 'cut', 'dcm', 'dcx', 'dib', 'djvu', 'dot', 'epdf', 'epi', 'eps', 'eps2', 'eps3','epsf', 'epsi', 'ept', 'exr', 'fax', 'fig', 'fits', 'gplt', 'gray', 'hpgl', 'ico', 'icon', 'info', 'jbig', 'bie', 'jbg', 'jng', 'jp2', 'jpc', 'mat', 'miff', 'mono', 'mng', 'mtv', 'mvg', 'otb', 'p7', 'palm', 'pam', 'pix', 'pcd', 'pcds', 'pcx', 'pdb', 'pef', 'pfa', 'pfb', 'pfb', 'pfm', 'picon', 'png8', 'png24', 'png32', 'ps', 'ps2', 'ps3', 'psd', 'ptif', 'pwp', 'rad', 'rgba', 'rla', 'rle', 'sct', 'sfw', 'sgi', 'sun', 'svg', 'tga', 'icb', 'vda', 'vst', 'tim', 'ttf', 'uil', 'uyvy', 'vicar', 'viff', 'wbmp', 'wpg', 'x', 'xcf', 'xpm', 'xwd', 'ycbcr', 'ycbcra', 'yuv'
  VALID_MIME_TYPES = Array.new
  VALID_TYPES.each_value { |value| VALID_MIME_TYPES << value }
  has_attachment :storage => :file_system, :processor => :rmagick, :max_size => 500.megabytes, :content_type => VALID_TYPES.collect {|key, value| value}, :thumbnails => Medium::COMMON_SIZES.merge(:jiats_essay => {:geometry => '350x>', :density => 260, :quality => 80}, :jiats_large => {:geometry => '700x>', :density => 300, :quality => 80}, :jiats_huge => {:geometry => '1200x>', :density => 300, :quality => 80})
  acts_as_tree
  validates_as_attachment
  has_one :picture, :foreign_key => 'attachment_id', dependent: :nullify
end