class CreateGlossaries < ActiveRecord::Migration
  def self.up
    create_table :glossaries, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :null => false
      t.column :description, :text
    end
    add_column :definitions, :glossary_id, :integer
    remove_index :definitions, [:definiendum_id, :definition_id]    
    add_index :definitions, [:definiendum_id, :definition_id, :glossary_id], :unique => true, :name => 'index_by_definition_definiendum_and_glossary'
  end

  def self.down
    remove_index :definitions, :name => 'index_by_definition_definiendum_and_glossary'
    drop_table :glossaries
    remove_column :definitions, :glossary_id
    add_index :definitions, [:definiendum_id, :definition_id], :unique => true
  end
end
