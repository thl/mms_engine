class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 10, :null => false
      t.column :order, :integer
    end
    add_index :letters, :title, :unique => true
  end

  def self.down
    drop_table :letters
  end
end
