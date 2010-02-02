class AddPartialTakenOnToMedium < ActiveRecord::Migration
  def self.up
    add_column :media, :partial_taken_on, :string
  end

  def self.down
    remove_column :media, :partial_taken_on
  end
end
