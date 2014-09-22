# == Schema Information
#
# Table name: application_filters
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class ApplicationFilter < ActiveRecord::Base
  def self.application_filter
    cached_filter('application_filter')
  end
  
  def self.default_filter
    cached_filter('default_filter')
  end
  
  def self.country_filter
    cached_filter('country_filter')
  end
  
  private
  
  def self.cached_filter(title)
    value = Rails.cache.fetch("#{self.table_name}_#{title}", :expires_in => 1.day) do
      setting = ApplicationSetting.find_by(title: title)
      setting.nil? || setting.value.nil? ? nil : setting.value
    end
    value.nil? ? nil : ApplicationFilter.find(value)
  end
end