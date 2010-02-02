class CreateRecordingOrientations < ActiveRecord::Migration
  def self.up
    create_table :recording_orientations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :recording_orientations
  end
end
