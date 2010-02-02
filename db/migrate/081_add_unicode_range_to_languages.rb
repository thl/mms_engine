class AddUnicodeRangeToLanguages < ActiveRecord::Migration
  def self.up
    add_column :languages, :unicode_codepoint_start, :integer
    add_column :languages, :unicode_codepoint_end, :integer
  end

  def self.down
    remove_column :languages, :unicode_codepoint_start
    remove_column :languages, :unicode_codepoint_end
  end
end
