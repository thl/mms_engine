class AddUserInformationToTranslation < ActiveRecord::Migration
  def self.up
    add_column :globalize_translations, :user_id, :integer
  end

  def self.down
    remove_column :globalize_translations, :user_id
  end
end
