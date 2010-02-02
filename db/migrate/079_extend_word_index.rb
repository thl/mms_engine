class ExtendWordIndex < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `words` DROP INDEX `index_words_on_title_and_language_id` , ADD UNIQUE `index_words_on_title_and_language_id` ( `title` ( 200 ) , `language_id` )"
  end

  def self.down
    execute "ALTER TABLE `words` DROP INDEX `index_words_on_title_and_language_id` , ADD UNIQUE `index_words_on_title_and_language_id` ( `title` ( 100 ) , `language_id` )"
  end
end
