class CreateWords < ActiveRecord::Migration
  def self.up
    create_table :words, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :text, :null => false
      t.column :language_id, :integer, :null => false
      t.column :order, :integer
      t.column :letter_id, :integer
    end
    execute "CREATE UNIQUE INDEX `index_words_on_title_and_language_id` ON words (title(100), `language_id`)"
    execute "ALTER TABLE words ADD FULLTEXT(title)"
  end
  
  def self.down
    drop_table :words
  end
end
