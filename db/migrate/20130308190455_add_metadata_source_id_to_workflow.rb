class AddMetadataSourceIdToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :metadata_source_id, :integer
  end
end
