class AddBatchProcessingFolderToApplicationSettings < ActiveRecord::Migration
  def self.up
    change_column :application_settings, :value, :integer, :null => true
    add_column :application_settings, :string_value, :string
    ApplicationSetting.reset_column_information
    
    application_setting = ApplicationSetting.find_by(title: 'batch_processing_folder')
    if application_setting.nil?
      application_setting = ApplicationSetting.create(:title => 'batch_processing_folder', :string_value => '../../batch-processing')
    else
      application_setting.string_value = '../../batch-processing'
      application_setting.save
    end
    
    application_setting = ApplicationSetting.find_by(title: 'cold_storage_folder')
    if application_setting.nil?
      application_setting = ApplicationSetting.create(:title => 'cold_storage_folder', :string_value => '../../coldstorage')
    else
      application_setting.string_value = '../../coldstorage'
      application_setting.save
    end
  end

  def self.down
  end
end
