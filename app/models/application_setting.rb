class ApplicationSetting < ActiveRecord::Base
  belongs_to :permission
  
  def configuration_path
    p = permission
    return nil if p.nil?
    url = p.title
    index = url.index('/')
    return url if index.nil?
    return { :controller => url[0...index], :action => url[index+1...url.size] }
  end
    
  def self.cold_storage_folder
    cold_storage_setting = ApplicationSetting.find_by_title('cold_storage_folder')
    if !cold_storage_setting.nil?
      cold_storage_folder = cold_storage_setting.string_value
      if !cold_storage_folder.blank?
        full_path = File.expand_path(cold_storage_folder)
        return full_path if File.exist?(full_path)
      end
    end
    return nil
  end  
end

# == Schema Info
# Schema version: 20100811203819
#
# Table name: application_settings
#
#  id            :integer(4)      not null, primary key
#  permission_id :integer(4)
#  description   :text
#  string_value  :string(255)
#  title         :string(30)      not null
#  value         :integer(4)