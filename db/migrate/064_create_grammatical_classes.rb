class CreateGrammaticalClasses < ActiveRecord::Migration
  def self.up
    create_table :grammatical_classes, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 50, :null => false
    end
    add_index :grammatical_classes, :title, :unique => true
  end

  def self.down
    drop_table :grammatical_classes
  end
end
