# == Schema Information
#
# Table name: application_settings
#
#  id            :integer          not null, primary key
#  title         :string(30)       not null
#  description   :text
#  value         :integer
#  permission_id :integer
#  string_value  :string(255)
#

class ApplicationSetting < ActiveRecord::Base
  attr_accessible :permission_id, :title, :value, :description, :string_value
  
  belongs_to :permission, :class_name => 'AuthenticatedSystem::Permission'
  
  def configuration_path
    p = permission
    return nil if p.nil?
    url = p.title
    index = url.index('/')
    return url if index.nil?
    return { :controller => url[0...index], :action => url[index+1...url.size] }
  end
    
  def self.cold_storage_folder
    Rails.cache.fetch("application_settings/cold_storage_folder", :expires_in => 1.day) do
      full_path = nil
      cold_storage_setting = ApplicationSetting.where(title: 'cold_storage_folder').first
      if !cold_storage_setting.nil?
        cold_storage_folder = cold_storage_setting.string_value
        if !cold_storage_folder.blank?
          full_path = File.expand_path(cold_storage_folder)
          full_path = nil if !File.exist?(full_path)
        end
      end
      full_path
    end
  end  
end
