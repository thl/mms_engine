class AddOriginalPathToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :original_path, :text
  end
end
