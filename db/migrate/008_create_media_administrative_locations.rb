class CreateMediaAdministrativeLocations < ActiveRecord::Migration
  def self.up
    create_table :media_administrative_locations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :administrative_unit_id, :integer, :null => false
      t.column :spot_feature, :text
      t.column :notes, :text
      t.column :type, :string, :limit => 50
    end
    add_index :media_administrative_locations, [:medium_id, :administrative_unit_id], :unique => true, :name => 'index_locations_on_medium_and_unit'
  end

  def self.down
    drop_table :media_administrative_locations
  end
end
