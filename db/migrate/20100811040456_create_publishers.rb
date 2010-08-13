class CreatePublishers < ActiveRecord::Migration
  def self.up
    create_table :publishers, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.integer :place_id
      t.integer :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :publishers
  end
end
