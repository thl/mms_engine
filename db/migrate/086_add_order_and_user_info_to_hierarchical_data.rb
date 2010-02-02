class AddOrderAndUserInfoToHierarchicalData < ActiveRecord::Migration
  def self.up
    add_column :administrative_units, :description, :text
    add_column :administrative_units, :creator_id, :integer
    add_column :administrative_units, :created_on, :timestamp
    add_column :administrative_units, :order, :integer

    add_column :subjects, :description, :text
    add_column :subjects, :creator_id, :integer
    add_column :subjects, :created_on, :timestamp
    add_column :subjects, :order, :integer

    add_column :ethnicities, :description, :text
    add_column :ethnicities, :creator_id, :integer
    add_column :ethnicities, :created_on, :timestamp
    add_column :ethnicities, :order, :integer        
  end

  def self.down
  end
end
