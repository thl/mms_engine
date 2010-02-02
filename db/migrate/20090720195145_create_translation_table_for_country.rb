class CreateTranslationTableForCountry < ActiveRecord::Migration
  def self.up
    create_table :country_translations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.references :country, :null => false
      t.string :locale, :null => false
      t.string :title
      t.timestamps
    end
    ComplexScripts.update_model_translation Country, [:title], [:dz]
    change_table :countries do |t|
      t.remove :title_dz
    end
  end

  def self.down
    change_table :countries do |t|
      t.string :title_dz
    end
    Country.reset_column_information
    ComplexScripts.undo_model_translation Country, [:title], [:dz]
    Country.drop_translation_table!
  end
end