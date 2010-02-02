class RemoveIndexOnCaptionsAndDescriptions < ActiveRecord::Migration
  def self.up
    remove_index :captions, 'title_and_type_and_language'
    remove_index :descriptions, 'title_and_type_and_language'
  end

  def self.down
    execute "CREATE UNIQUE INDEX `index_captions_on_title_and_type_and_language` ON captions (title(100), `description_type_id`, `language_id`)"
    execute "CREATE UNIQUE INDEX `index_descriptions_on_title_and_type_and_language` ON descriptions (title(100), `description_type_id`, `language_id`)"
  end
end
