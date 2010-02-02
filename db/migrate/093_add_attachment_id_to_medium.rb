class AddAttachmentIdToMedium < ActiveRecord::Migration
  def self.up
    add_column :media, :attachment_id, :integer, :null => true
    Medium.update_all ('attachment_id = image_id', ['type = ?', 'Picture'])
    Medium.update_all ('attachment_id = movie_id', ['type = ?', 'Video'])
    Medium.update_all ('attachment_id = typescript_id', ['type = ?', 'Document'])
    change_column :media, :attachment_id, :integer, :null => false
    remove_index :media, [:image_id, :movie_id, :typescript_id]    
    remove_column :media, :image_id
    remove_column :media, :movie_id
    remove_column :media, :typescript_id
    add_index :media, [:type, :attachment_id], :unique => true
  end

  def self.down
    add_column :media, :image_id, :integer, :null => true
    add_column :media, :movie_id, :integer, :null => true
    add_column :media, :typescript_id, :integer, :null => true
    Medium.update_all ('image_id = attachment_id', ['type = ?', 'Picture'])
    Medium.update_all ('movie_id = attachment_id', ['type = ?', 'Video'])
    Medium.update_all ('typescript_id = attachment_id', ['type = ?', 'Document'])
    add_index :media, [:image_id, :movie_id, :typescript_id]
    remove_index :media, [:type, :attachment_id]
    remove_column :media, :attachment_id
  end
end
