class CreateAdministrativeLevels < ActiveRecord::Migration
  def self.up
    create_table :administrative_levels, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 100, :null => false
      t.column :country_id, :integer, :null => false
      t.column :level, :integer, :null => false
    end
    add_index :administrative_levels, [:title, :country_id], :unique => true
    
    country = Country.find(1)
    AdministrativeLevel.create :country => country, :level => 1, :title => 'District'
    AdministrativeLevel.create :country => country, :level => 2, :title => 'Block'
    AdministrativeLevel.create :country => country, :level => 3, :title => 'Village'
  end

  def self.down
    drop_table :administrative_levels
  end
end
