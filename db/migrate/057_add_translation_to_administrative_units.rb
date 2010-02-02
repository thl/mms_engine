class AddTranslationToAdministrativeUnits < ActiveRecord::Migration
  def self.up
    add_column :administrative_units, :title_dz, :string, :limit => 100
  end

  def self.down
    remove_column :administrative_units, :title_dz
  end
end
