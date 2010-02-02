class AddTakenOnAndOrientationAndCaptureModelToMedium < ActiveRecord::Migration
  def self.up
    add_column :media, :taken_on, :datetime
    add_column :media, :recording_orientation_id, :integer
    add_column :media, :capture_device_model_id, :integer
  end

  def self.down
    remove_column :media, :taken_on
    remove_column :media, :recording_orientation_id
    remove_column :media, :capture_device_model_id
  end
end
