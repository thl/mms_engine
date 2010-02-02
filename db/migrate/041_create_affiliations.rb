class CreateAffiliations < ActiveRecord::Migration
  def self.up
    create_table :affiliations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :sponsor_id, :integer
      t.column :organization_id, :integer, :null => false
      t.column :project_id, :integer
    end
  end

  def self.down
    drop_table :affiliations
  end
end
