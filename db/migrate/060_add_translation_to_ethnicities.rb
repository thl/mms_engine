class AddTranslationToEthnicities < ActiveRecord::Migration
  def self.up
   add_column :ethnicities, :title_dz, :string, :limit => 100
  end

  def self.down
   remove_column :ethnicities, :title_dz
  end
end
