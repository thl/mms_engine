class AddResourceTypeIdToMedium < ActiveRecord::Migration
  def self.up
    add_column :media, :resource_type_id, :integer
    Medium.reset_column_information
    Medium.update_all('resource_type_id = 2660', :type => 'Picture')
    Medium.update_all('resource_type_id = 2687', :type => 'Video')
    Medium.update_all('resource_type_id = 2639', :type => 'Document')
    change_column :media, :resource_type_id, :integer, :null => false
  end

  def self.down
    remove_column :media, :resource_type_id
  end
end
