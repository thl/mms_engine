class CreateMediaCategoryAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_category_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :medium_id, :null => false
      t.integer :category_id, :null => false
      t.integer :root_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :media_category_associations
  end
end
