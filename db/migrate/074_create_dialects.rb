class CreateDialects < ActiveRecord::Migration
  def self.up
    create_table :dialects, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 140, :null => false
    end
    add_column :definitions, :dialect_id, :integer
  end

  def self.down
    drop_table :dialects
    remove_column :definitions, :dialect_id
  end
end
