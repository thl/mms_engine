class AddTranslationToCountries < ActiveRecord::Migration
  def self.up
    add_column :countries, :title_dz, :string, :limit => 100
  end

  def self.down
    remove_column :countries, :title_dz
  end
end
