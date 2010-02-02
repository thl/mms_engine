class AddPermalinkToCollections < ActiveRecord::Migration
  def self.up
    add_column :collections, :permalink, :string
  end

  def self.down
    remove_column :collections, :permalink
  end
end
