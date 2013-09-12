# == Schema Information
#
# Table name: web_addresses
#
#  id                 :integer          not null, primary key
#  url                :string(255)      not null
#  parent_resource_id :integer
#  online_resource_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class WebAddress < ActiveRecord::Base
  validates_presence_of :url, :online_resource_id
  attr_accessible :parent_resource_id, :url
  belongs_to :parent_resource, :class_name => 'OnlineResource'
  belongs_to :online_resource
end
