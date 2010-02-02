class CreateTypescripts < ActiveRecord::Migration
  def self.up
    create_table :typescripts, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string, :limit => 10
      
      # required for images only
      t.column "width", :integer  
      t.column "height", :integer
      t.column :transformation_id, :integer
    end
    remove_index :media, [:image_id, :movie_id]
    add_column :media, :typescript_id, :integer, :null => true, :default => nil
    add_index :media, [:image_id, :movie_id, :typescript_id], :unique => true
  end

  def self.down
    drop_table :typescripts
    remove_index :media, [:image_id, :movie_id, :typescript_id]
    Medium.delete_all('typescript_id IS NOT NULL')
    remove_column :media, :typescript_id
    add_index :media, [:image_id, :movie_id], :unique => true
  end
end