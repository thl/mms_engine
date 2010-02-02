class CreateApplicationSettings < ActiveRecord::Migration
  def self.up
    create_table :application_settings, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 30, :null => false
      t.column :description, :text
      t.column :value, :integer, :null => false
      t.column :permission_id, :integer
    end
  end

  def self.down
    drop_table :application_settings
  end
end
