class CreateCountries < ActiveRecord::Migration
  # this is to ensure that our app's country is not confused with Globalize::Country
  require 'app/models/country.rb'
  def self.up
    create_table :countries, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 100, :null => false
    end
    add_index :countries, :title, :unique => true
    Country.create :title => 'Bhutan'
  end

  def self.down
    drop_table :countries
  end
end
