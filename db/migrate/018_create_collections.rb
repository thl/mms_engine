class CreateCollections < ActiveRecord::Migration
  def self.up
    create_table :collections, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :null => false
      t.column :description, :text
      t.column :creator_id, :integer
      t.column :created_on, :timestamp
      t.column :order, :integer
      t.column :parent_id, :integer
    end
    add_index :collections, :title, :unique => true
  end

  def self.down
    drop_table :collections
  end
end
