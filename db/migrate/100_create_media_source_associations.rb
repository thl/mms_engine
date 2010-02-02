class CreateMediaSourceAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_source_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :medium_id, :null => false
      t.integer :source_id, :null => false
      t.integer :shot_number

      t.timestamps
    end
  end

  def self.down
    drop_table :media_source_associations
  end
end
