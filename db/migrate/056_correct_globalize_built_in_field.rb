include Globalize

class CorrectGlobalizeBuiltInField < ActiveRecord::Migration
  def self.up
    change_column :globalize_translations, :built_in, :boolean, :default => nil
    ViewTranslation.update_all ['built_in = ?', nil], ['id > ?', 7030]
  end

  def self.down
    change_column :globalize_translations, :built_in, :boolean, :default => true
    ViewTranslation.update_all ['built_in = ?', true]
  end
end
