class CreateDescriptionsMedia < ActiveRecord::Migration
  def self.up
    create_table :descriptions_media, :options =>'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.column :medium_id, :integer, :null => false
      t.column :description_id, :integer, :null => false
    end
    add_index :descriptions_media, [:medium_id, :description_id], :unique => true
  end

  def self.down
    drop_table :descriptions_media
  end
end
