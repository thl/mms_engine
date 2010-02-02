class AddTranslationToSubjects < ActiveRecord::Migration
  def self.up
   add_column :subjects, :title_dz, :string, :limit => 100
  end

  def self.down
   remove_column :subjects, :title_dz
  end
end
