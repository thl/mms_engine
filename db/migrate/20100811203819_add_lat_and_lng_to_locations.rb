class AddLatAndLngToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :lat, :decimal, :precision => 9, :scale => 6
    add_column :locations, :lng, :decimal, :precision => 9, :scale => 6
  end

  def self.down
    remove_column :locations, :lng
    remove_column :locations, :lat
  end
end
