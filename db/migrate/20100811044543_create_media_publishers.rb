class CreateMediaPublishers < ActiveRecord::Migration
  def self.up
    create_table :media_publishers, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :publisher_id
      t.integer :medium_id
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :media_publishers
  end
end
