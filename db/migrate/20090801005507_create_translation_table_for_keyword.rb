class CreateTranslationTableForKeyword < ActiveRecord::Migration
  def self.up
    create_table :keyword_translations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.references :keyword, :null => false
      t.string :locale, :null => false
      t.string :title
      t.timestamps
    end
    ComplexScripts.update_model_translation Keyword, [:title], [:dz]
    change_table :keywords do |t|
      t.remove :title_dz
    end
  end

  def self.down
    change_table :keywords do |t|
      t.string :title_dz
    end
    Keyword.reset_column_information
    ComplexScripts.undo_model_translation Keyword, [:title], [:dz]
    Keyword.drop_translation_table!
  end
end
