class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords, :options =>'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci'  do |t|
      t.column :title, :string, :limit => 100, :null => false
    end
    add_index :keywords, :title, :unique => true
  end

  def self.down
    drop_table :keywords
  end
end
