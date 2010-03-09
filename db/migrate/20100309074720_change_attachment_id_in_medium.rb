class ChangeAttachmentIdInMedium < ActiveRecord::Migration
  def self.up
    remove_index :media, [:type, :attachment_id]
    change_column :media, :attachment_id, :integer, :null => true
    add_index :media, [:type, :attachment_id]
  end

  def self.down
    remove_index :media, [:type, :attachment_id]
    change_column :media, :attachment_id, :integer, :null => false
    add_index :media, [:type, :attachment_id], :unique => true
  end
end
