class ExtendLanguageCode < ActiveRecord::Migration
  def self.up
    Globalize::Language.create :iso_639_3 => 'jee', :english_name => 'Jerung',  :macro_language => 0, :direction => 'ltr', :scope => 'L'
    Globalize::Language.create :iso_639_3 => 'wme', :english_name => 'Wambule', :macro_language => 0, :direction => 'ltr', :scope => 'L'
    Globalize::Language.create :iso_639_3 => 'thf', :english_name => 'Thangmi', :macro_language => 0, :direction => 'ltr', :scope => 'L'
  end

  def self.down
  end
end
