# == Schema Information
#
# Table name: movies
#
#  id           :integer          not null, primary key
#  content_type :string(255)
#  filename     :string(255)
#  size         :integer
#  parent_id    :integer
#  thumbnail    :string(10)
#  width        :integer
#  height       :integer
#  status       :integer          default(0)
#

class Movie < ActiveRecord::Base
  VALID_TYPES = {'4xm' => 'audio/x-adpcm', 'mtv' => 'image/x-mtv', 'aac' => 'audio/x-aac', 'ac3' => 'audio/x-ac3', 'aif' => 'audio/x-aiff', 'aifc' => 'audio/x-aiff', 'aiff' => 'audio/x-aiff', 'alaw' => 'audio/x-alaw', 'amr' => 'video/3gpp', 'asf' => 'video/x-ms-asf', 'au' => 'audio/basic', 'avi' => 'video/x-msvideo', 'avs' => 'video/avs-video', 'dv' => 'video/x-dv', 'ffm' => 'video/x-ffv', 'flac' => 'audio/x-flac', 'fli' => 'video/fli', 'flc' => 'video/flc', 'flx' => 'text/vnd.fmi.flexstor', 'flv' => 'video/x-flv', 'gif' => 'image/gif', 'h261' => 'video/x-h261', 'h263' => 'video/x-h263', 'h264' => 'video/x-h264', 'ipmovie' => 'video/x-mve', 'm4v' => 'video/x-m4v', 'matroska' => 'video/x-matroska', 'mjpg' => 'video/x-motion-jpeg', 'mjpeg' => 'video/x-motion-jpeg', 'mm' => 'application/base64', 'mmf' => 'application/vnd.smaf', 'mov' => 'video/quicktime', 'mp4' => 'video/mp4', 'm4a' => 'audio/mp4a-latm', '3gp' => 'video/3gpp', '3g2' => 'video/3gpp2', 'mj2' => 'video/mj2', 'mp3' => 'audio/mpeg', 'mpc' => 'application/x-project', 'mpe' => 'video/mpeg', 'mpeg' => 'video/mpeg', 'mp2' => 'audio/mpeg-2', 'mpg2' => 'video/mpeg', 'mpg' => 'video/mpeg', 'mulaw' => 'audio/x-mulaw', 'mxf' => 'application/mxf', 'nsv' => 'video/x-nsv', 'nuv' => 'video/x-nuv', 'ogg' => 'application/ogg', 'rawvideo' => 'video/raw', 'rm' => 'application/vnd.rn-realmedia', 'sdp' => 'application/sdp', 'smk' => 'video/x-smacker', 'sol' => 'application/solids', 'swf' => 'application/x-shockwave-flash', 'seq' => 'audio/x-tone-seq', 'tta' => 'audio/x-tta', 'vc1' => 'video/vc1', 'vmd' => 'application/vocaltec-media-desc', 'voc' => 'audio/x-voc', 'wav' => 'audio/x-wav', 'wv' => 'audio/x-wv', 'yuv' => 'video/x-raw-yuv', 'jpg' =>'image/jpeg'}
  has_attachment :storage => :file_system, :processor => :rmagick, :max_size => 500.megabytes, :content_type => VALID_TYPES.collect {|key, value| value} 
  acts_as_tree
  has_one :video, :foreign_key => 'attachment_id'
end