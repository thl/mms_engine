class CreateTitles < ActiveRecord::Migration
  def self.up
    create_table :titles, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.column :creator_id, :integer
      t.references :medium, :null => false
      t.references :language, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :titles
  end
end
