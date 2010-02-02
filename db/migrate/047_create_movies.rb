class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string, :limit => 10
      
      # required for images only
      t.column "width", :integer  
      t.column "height", :integer
    end
    remove_index :media, :image_id
    add_column :media, :movie_id, :integer, :null => true, :default => nil
    add_column :media, :type, :string, :limit => 10
    add_column :media, :status, :integer, :default => 0
    Medium.update_all 'type = \'Picture\''
    change_column :media, :type, :string, :limit => 10, :null => false 
    change_column :media, :image_id, :integer, :null => true, :default => nil
    add_index :media, [:image_id, :movie_id], :unique => true
  end

  def self.down
    drop_table :movies
    remove_index :media, [:image_id, :movie_id]
    Medium.delete_all('image_id IS NULL')
    remove_column :media, :movie_id
    remove_column :media, :type
    remove_column :media, :status
    add_index :media, :image_id, :unique => true 
  end
end