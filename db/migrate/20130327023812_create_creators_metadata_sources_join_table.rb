class CreateCreatorsMetadataSourcesJoinTable < ActiveRecord::Migration
  def change
    create_table :creators_metadata_sources, :id => false do |t|
      t.integer :creator_id, :null => false
      t.integer :metadata_source_id, :null => false
    end
    remove_column :metadata_sources, :creator_id
  end
end
