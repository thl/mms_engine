class ChangeTitleInTitlesAndTranslatedTitles < ActiveRecord::Migration
  def self.up
    change_column :titles, :title, :text, :null => false
    change_column :translated_titles, :title, :text, :null => false
    execute "ALTER TABLE titles ADD FULLTEXT(title)"
    execute "ALTER TABLE translated_titles ADD FULLTEXT(title)"
  end

  def self.down
    execute "ALTER TABLE titles DROP INDEX `title`"
    execute "ALTER TABLE translated_titles DROP INDEX `title`"
    change_column :titles, :title, :string, :null => false
    change_column :translated_titles, :title, :string, :null => false
  end
end
