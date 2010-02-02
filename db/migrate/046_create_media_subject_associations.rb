class CreateMediaSubjectAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_subject_associations,:options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :subject_id, :integer, :null => false
      t.column :medium_id, :integer, :null => false
    end
    add_index :media_subject_associations, [:medium_id, :subject_id], :unique => true, :name => 'index_associations_on_medium_and_subject'
  end

  def self.down
    drop_table :media_subject_associations
  end
end
