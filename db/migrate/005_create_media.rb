class CreateMedia < ActiveRecord::Migration
  def self.up
    create_table :media, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :image_id, :integer, :null => false
      t.column :photographer_id, :integer
      t.column :quality_type_id, :integer
      t.column :thdl_code, :string, :limit => 50
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
      t.column :recording_note, :text
      t.column :private_note, :text
    end
    add_index :media, :image_id, :unique => true
  end

  def self.down
    drop_table :media
  end
end
