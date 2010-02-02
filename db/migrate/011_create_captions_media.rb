class CreateCaptionsMedia < ActiveRecord::Migration
  def self.up
    create_table :captions_media, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci', :id => false do |t|
    t.column :medium_id, :integer, :null => false
    t.column :caption_id, :integer, :null => false
    end
    add_index :captions_media, [:medium_id, :caption_id], :unique => true
  end

  def self.down
    drop_table :captions_media
  end
end
