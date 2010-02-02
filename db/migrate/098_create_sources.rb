class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
