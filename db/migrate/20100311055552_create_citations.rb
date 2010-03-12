class CreateCitations < ActiveRecord::Migration
  def self.up
    create_table :citations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :reference_id, :null => false
      t.string :reference_type, :null => false
      t.column :creator_id, :integer
      t.integer :medium_id
      t.integer :page_number
      t.string :page_side, :limit => 5
      t.integer :line_number
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :citations
  end
end
