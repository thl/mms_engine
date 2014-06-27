class CreateCumulativeMediaLocationAssociations < ActiveRecord::Migration
  def change
    create_table :cumulative_media_location_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :medium_id, :null => false
      t.integer :feature_id, :null => false
      t.timestamps
    end
    add_index :cumulative_media_location_associations, [:feature_id, :medium_id], :unique => true, :name => 'by_medium_location'
  end
end
