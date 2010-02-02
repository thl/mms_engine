class AddTranslationToCollections < ActiveRecord::Migration
  def self.up
    add_column :collections, :title_dz, :string, :limit => 100
  end

  def self.down
   remove_column :collections, :title_dz
  end
end
