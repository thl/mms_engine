class CreateAdministrativeUnits < ActiveRecord::Migration
  require 'csv'
  def self.up
    create_table :administrative_units, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 100, :null => false
      t.column :administrative_level_id, :integer, :null => false
      t.column :parent_id, :integer
    end
    add_index :administrative_units, [:title, :administrative_level_id, :parent_id], :unique => true, :name => 'index_units_on_title_and_level_and_parent'
    return if !File.exists? 'db/migrate/units/administrative_units.csv'
    levels = [AdministrativeLevel.find(1), AdministrativeLevel.find(2), AdministrativeLevel.find(3)]
    units = Array.new(3)
    previous_row = Array.new(3)
    CSV.open('db/migrate/units/administrative_units.csv', 'r') do |row|
      row.size.times do |i|
        col = row[i]
        next if col.blank?
        col.strip!
        if col != previous_row[i]
          if i>0
            parent = units[i-1]
          else
            parent = nil
          end
          previous_row[i] = col
          units[i] = AdministrativeUnit.find(:first, :conditions => { :title => col, :administrative_level_id => levels[i], :parent_id => parent })
          units[i]= AdministrativeUnit.create(:title => col, :administrativeLevel => levels[i], :parent => parent) if units[i].nil?
        end
      end
    end
  end

  def self.down
    drop_table :administrative_units
  end
end
