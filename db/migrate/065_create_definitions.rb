class CreateDefinitions < ActiveRecord::Migration
  def self.up
    create_table :definitions, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :definiendum_id, :integer, :null => false
      t.column :definition_id, :integer, :null => false
      t.column :grammatical_class_id, :integer
    end
    add_index :definitions, [:definiendum_id, :definition_id], :unique => true
  end

  def self.down
    drop_table :definitions
  end
end
