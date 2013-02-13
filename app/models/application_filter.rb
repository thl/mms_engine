class ApplicationFilter < ActiveRecord::Base
  attr_accessible :title
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
    value = Rails.cache.fetch("#{self.table_name}_#{title}") do
      setting = ApplicationSetting.find_by_title(title)
      setting.nil? || setting.value.nil? ? nil : setting.value
    end
    value.nil? ? nil : ApplicationFilter.find(value)
  end
end

# == Schema Info
# Schema version: 20110412155958
#
# Table name: application_filters
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime