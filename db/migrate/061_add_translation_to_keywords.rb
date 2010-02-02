class AddTranslationToKeywords < ActiveRecord::Migration
  def self.up
    add_column :keywords, :title_dz, :string, :limit => 100
  end

  def self.down
   remove_column :keywords, :title_dz
  end
end
