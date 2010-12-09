class DropAdministrativeUnitTables < ActiveRecord::Migration
  def self.up
    [:administrative_levels, :administrative_units, :countries, :globalize_countries, :globalize_languages, :globalize_translations].each{ |table| drop_table table }
  end

  def self.down
  end
end
