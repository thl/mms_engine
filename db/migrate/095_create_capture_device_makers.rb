class CreateCaptureDeviceMakers < ActiveRecord::Migration
  def self.up
    create_table :capture_device_makers, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :capture_device_makers
  end
end
