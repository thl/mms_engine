class CreateCaptureDeviceModels < ActiveRecord::Migration
  def self.up
    create_table :capture_device_models, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :capture_device_maker_id
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :capture_device_models
  end
end
