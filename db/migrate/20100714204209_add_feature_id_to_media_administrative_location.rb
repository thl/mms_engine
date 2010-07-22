class AddFeatureIdToMediaAdministrativeLocation < ActiveRecord::Migration
  class MediaAdministrativeLocation < ActiveRecord::Base
    belongs_to :administrative_unit
  end
  
  def self.up
    change_table :media_administrative_locations do |t|
      t.integer :feature_id
      MediaAdministrativeLocation.all(:order => :id).each { |location| location.update_attribute(:feature_id, location.administrative_unit.feature_id) }
      t.change :feature_id, :integer, :null => false
      t.remove_index :name => 'index_locations_on_medium_and_unit'
      t.remove :administrative_unit_id
    end
    rename_table :media_administrative_locations, :locations
    add_index :locations, [:medium_id, :feature_id], :unique => true
  end

  def self.down
    remove_index :locations, :column => [:medium_id, :feature_id]
    rename_table :locations, :media_administrative_locations
    change_table :media_administrative_locations do |t|
      t.integer :administrative_unit_id
      MediaAdministrativeLocation.all(:order => :id).each { |location| location.update_attribute(:administrative_unit_id, AdministrativeUnit.find_by_feature_id(location.feature_id)).id }
      t.change :administrative_unit_id, :integer, :null => false
      t.index [:medium_id, :administrative_unit_id], :unique => true, :name => 'index_locations_on_medium_and_unit'
      t.remove :feature_id
    end
  end
end
