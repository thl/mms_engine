class CreateMediaEthnicityAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_ethnicity_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :ethnicity_id, :integer, :null => false
    end
    add_index :media_ethnicity_associations, [:medium_id, :ethnicity_id], :unique => true, :name => 'index_associations_on_medium_and_ethnicity'
  end

  def self.down
    drop_table :media_ethnicity_associations
  end
end
