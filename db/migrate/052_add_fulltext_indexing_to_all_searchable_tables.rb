class AddFulltextIndexingToAllSearchableTables < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE captions ADD FULLTEXT(title)"
    execute "ALTER TABLE descriptions ADD FULLTEXT(title)"
    execute "ALTER TABLE administrative_units ADD FULLTEXT(title)"
    execute "ALTER TABLE collections ADD FULLTEXT(title)"
    execute "ALTER TABLE ethnicities ADD FULLTEXT(title)"
    execute "ALTER TABLE keywords ADD FULLTEXT(title)"
    execute "ALTER TABLE subjects ADD FULLTEXT(title)"
  end

  def self.down
    execute "ALTER TABLE captions DROP INDEX `title`"
    execute "ALTER TABLE descriptions DROP INDEX `title`"
    execute "ALTER TABLE administrative_units DROP INDEX `title`"
    execute "ALTER TABLE collections DROP INDEX `title`"
    execute "ALTER TABLE ethnicities DROP INDEX `title`"
    execute "ALTER TABLE keywords DROP INDEX `title`"
    execute "ALTER TABLE subjects DROP INDEX `title`"
  end
end
