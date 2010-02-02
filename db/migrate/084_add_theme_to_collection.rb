class AddThemeToCollection < ActiveRecord::Migration
  def self.up
    add_column :collections, :registered_theme_id, :integer
  end

  def self.down
    remove_column :collections, :registered_theme_id
  end
end
