class CreateOrganizations < ActiveRecord::Migration
  def self.up
    create_table :organizations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 250, :null => false
    end
  end

  def self.down
    drop_table :organizations
  end
end
