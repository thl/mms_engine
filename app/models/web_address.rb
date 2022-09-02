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
  belongs_to :parent_resource, :class_name => 'OnlineResource'
  belongs_to :online_resource
  
  def absolute_url
    return url if parent_resource.nil? || !self.url.start_with?('/')
    p = self.parent_resource.reload # don't know why reload is necessary but doesn't work otherwise!
    uri = URI.parse(p.web_address.url)
    return "#{uri.scheme}://#{uri.host}#{self.url}"
  end
end
