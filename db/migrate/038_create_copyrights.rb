class CreateCopyrights < ActiveRecord::Migration
  def self.up
    create_table :copyrights, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :copyright_holder_id, :integer, :null => false
      t.column :reproduction_type_id, :integer, :null => false
      t.column :notes, :text
    end
  end

  def self.down
    drop_table :copyrights
  end
end
