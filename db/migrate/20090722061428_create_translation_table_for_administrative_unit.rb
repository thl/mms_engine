class CreateTranslationTableForAdministrativeUnit < ActiveRecord::Migration
  def self.up
    create_table :administrative_unit_translations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.references :administrative_unit, :null => false
      t.string :locale, :null => false
      t.string :title
      t.timestamps
    end
    ComplexScripts.update_model_translation AdministrativeUnit, [:title], [:dz]
    change_table :administrative_units do |t|
      t.remove :title_dz
    end
  end

  def self.down
    change_table :administrative_units do |t|
      t.string :title_dz
    end
    AdministrativeUnit.reset_column_information
    ComplexScripts.undo_model_translation AdministrativeUnit, [:title], [:dz]
    AdministrativeUnit.drop_translation_table!
  end
end
