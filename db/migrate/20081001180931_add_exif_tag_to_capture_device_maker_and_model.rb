class AddExifTagToCaptureDeviceMakerAndModel < ActiveRecord::Migration
  def self.up
    add_column :capture_device_makers, :exif_tag, :string
    add_column :capture_device_models, :exif_tag, :string
  end

  def self.down
    remove_column :capture_device_makers, :exif_tag
    remove_column :capture_device_models, :exif_tag
  end
end
