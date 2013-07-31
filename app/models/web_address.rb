class WebAddress < ActiveRecord::Base
  validates_presence_of :url, :online_resource_id
  attr_accessible :parent_resource_id, :url
  belongs_to :parent_resource, :class_name => 'OnlineResource'
  belongs_to :online_resource
end
