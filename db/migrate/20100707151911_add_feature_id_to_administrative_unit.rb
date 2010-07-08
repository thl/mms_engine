class AddFeatureIdToAdministrativeUnit < ActiveRecord::Migration
  def self.up
    add_column :administrative_units, :feature_id, :integer
  end

  def self.down
    remove_column :administrative_units, :feature_id
  end
end
