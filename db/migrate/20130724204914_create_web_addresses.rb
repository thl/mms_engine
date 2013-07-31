class CreateWebAddresses < ActiveRecord::Migration
  def up
    create_table :web_addresses do |t|
      t.string :url, :null => false
      t.integer :parent_resource_id
      t.integer :online_resource_id, :null => false
      t.timestamps
    end
    change_column :media, :type, :string, :limit => 20
  end
  
  def down
    drop_table :web_addresses
    change_column :media, :type, :string, :limit => 10
  end
end