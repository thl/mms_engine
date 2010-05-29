class ChangeOriginalMediumIdInWorkflows < ActiveRecord::Migration
  def self.up
    change_column :workflows, :original_medium_id, :text, :null => false
    execute "ALTER TABLE workflows ADD FULLTEXT(original_medium_id)"
  end

  def self.down
    execute "ALTER TABLE workflows DROP INDEX `original_medium_id`"
    change_column :workflows, :original_medium_id, :string, :null => false
  end
end
