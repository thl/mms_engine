class ChangeOriginalFilenameInWorkflows < ActiveRecord::Migration
  def self.up
    change_column :workflows, :original_filename, :string, :null => true
  end

  def self.down
    change_column :workflows, :original_filename, :string, :null => false
  end
end
