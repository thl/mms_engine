class CreateDefinitionsKeywords < ActiveRecord::Migration
  def self.up
    create_table :definitions_keywords, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
      t.column :definition_id, :integer, :null => false
      t.column :keyword_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :keywords_words
  end
end
