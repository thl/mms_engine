class CreateMediaKeywordAssociations < ActiveRecord::Migration
  def self.up
    create_table :media_keyword_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :medium_id, :integer, :null => false
      t.column :keyword_id, :integer, :null => false
    end
    add_index :media_keyword_associations, [:medium_id, :keyword_id], :unique => true
  end

  def self.down
    drop_table :media_keyword_associations
  end
end
