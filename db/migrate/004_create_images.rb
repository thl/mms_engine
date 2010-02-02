class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column "content_type", :string
      t.column "filename", :string     
      t.column "size", :integer
      
      # used with thumbnails, always required
      t.column "parent_id",  :integer 
      t.column "thumbnail", :string
      
      # required for images only
      t.column "width", :integer  
      t.column "height", :integer
    end
  end

  def self.down
    drop_table :images
    
    # only for db-based files
    # drop_table :db_files
  end
end
