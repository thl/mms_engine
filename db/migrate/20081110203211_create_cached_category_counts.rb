class CreateCachedCategoryCounts < ActiveRecord::Migration
  def self.up
    create_table :cached_category_counts, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :category_id, :null => false
      t.string :medium_type
      t.integer :count, :null => false
      t.timestamps
    end
    add_index :copyrights, :medium_id, :unique => true
    add_index :copyright_holders, :title, :unique => true
    add_index :reproduction_types, :title, :unique => true
    add_index :affiliations, [:medium_id, :sponsor_id, :organization_id, :project_id], :unique => true, :name => 'by_medium_sponsor_organization_project'
    add_index :organizations, :title, :unique => true
    add_index :projects, :title, :unique => true
    add_index :sponsors, :title, :unique => true
    add_index :renderers, :title, :unique => true
    add_index :renderers, :path, :unique => true
    add_index :transformations, :path, :unique => true
    add_index :transformations, [:renderer_id, :title], :unique => true
    add_index :application_settings, :title, :unique => true
    add_index :registered_themes, :namespace, :unique => true
    add_index :registered_themes, :title, :unique => true
    add_index :loan_types, :title, :unique => true
    add_index :dialects, :title, :unique => true
    add_index :glossaries, :title, :unique => true
    add_index :definitions_keywords, [:definition_id, :keyword_id], :unique => true
    add_index :capture_device_makers, :title, :unique => true
    add_index :capture_device_models, [:capture_device_maker_id, :title], :unique => true
    add_index :recording_orientations, :title, :unique => true
    add_index :sources, :title, :unique => true
    add_index :workflows, :medium_id, :unique => true
    add_index :media_source_associations, [:medium_id, :source_id], :unique => true
    add_index :category_registered_theme_associations, :permalink, :unique => true
    add_index :category_registered_theme_associations, [:category_id, :registered_theme_id], :unique => true, :name => 'by_category_registered_theme'
    add_index :media_category_associations, [:medium_id, :category_id], :unique => true
    add_index :cached_category_counts, [:category_id, :medium_type], :unique => true
  end

  def self.down
    drop_table :cached_category_counts
  end
end
