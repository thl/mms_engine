class AddIsPublicToGlossay < ActiveRecord::Migration
  def self.up
    add_column :glossaries, :is_public, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :glossaries, :is_public
  end
end
