class AddRotationToMedium < ActiveRecord::Migration
  def self.up
    add_column :media, :rotation, :integer
  end

  def self.down
    remove_column :media, :rotation
  end
end
