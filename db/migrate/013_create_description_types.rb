class CreateDescriptionTypes < ActiveRecord::Migration
  def self.up
    create_table :description_types, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 100, :null => false
    end
    add_index :description_types, :title, :unique => true
    DescriptionType.create :title => 'General'
  end

  def self.down
    drop_table :description_types
  end
end
