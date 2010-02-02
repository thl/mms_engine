class AddIsProblematicToAdministrativeUnit < ActiveRecord::Migration
  def self.up
    add_column :administrative_units, :is_problematic, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :administrative_units, :is_problematic
  end
end
