class AddAbbreviationAndOrganizationToGlossary < ActiveRecord::Migration
  def self.up
    add_column :glossaries, :abbreviation, :string, :limit => 20
    add_column :glossaries, :organization_id, :integer
  end

  def self.down
    remove_column :glossaries, :abbreviation
    remove_column :glossaries, :organization_id
  end
end
