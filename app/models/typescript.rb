# == Schema Information
# Schema version: 20090626173648
#
# Table name: typescripts
#
#  id                :integer(4)      not null, primary key
#  content_type      :string(255)
#  filename          :string(255)
#  size              :integer(4)
#  parent_id         :integer(4)
#  thumbnail         :string(10)
#  width             :integer(4)
#  height            :integer(4)
#  transformation_id :integer(4)
#

class Typescript < ActiveRecord::Base
  VALID_TYPES = { 'xml' => 'text/xml', 'pdf' => 'application/pdf', 'gif' => 'image/gif', 'jpe' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'jpg' => 'image/jpeg', 'pjpeg' => 'image/pjpeg', 'png' => 'image/png'}
  has_attachment :storage => :file_system, :processor => :rmagick, :max_size => 100.megabytes, :content_type => VALID_TYPES.collect {|key, value| value} 
  acts_as_tree
  validates_as_attachment
  has_one :document, :foreign_key => 'attachment_id'
  belongs_to :transformation
end
