class AddProcessingStatusIdToWorkflow < ActiveRecord::Migration
  def self.up
    add_column :workflows, :processing_status_id, :integer
  end

  def self.down
    remove_column :workflows, :processing_status_id
  end
end
