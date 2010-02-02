class DropCollectionsEthniticiesAndSubjects < ActiveRecord::Migration
  def self.up
    drop_table :collections
    drop_table :ethnicities
    drop_table :subjects
    drop_table :media_collection_associations
    drop_table :media_ethnicity_associations
    drop_table :media_subject_associations
  end

  def self.down
  end
end
