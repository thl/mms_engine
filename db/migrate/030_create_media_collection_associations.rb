class CreateMediaCollectionAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_collection_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :collection_id, :integer, :null => false
    end
    add_index :media_collection_associations, [:medium_id, :collection_id], :unique => true, :name => 'index_associations_on_medium_and_collection'
  end

  def self.down
    drop_table :media_collection_associations
  end
end
