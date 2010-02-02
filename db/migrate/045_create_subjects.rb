class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :null => false
      t.column :parent_id, :integer
    end
    add_index :subjects, :title, :unique => true
  end

  def self.down
    drop_table :subjects
  end
end
