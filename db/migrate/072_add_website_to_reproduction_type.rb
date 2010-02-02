class AddWebsiteToReproductionType < ActiveRecord::Migration
  def self.up
    add_column :reproduction_types, :website, :string
    add_column :reproduction_types, :order, :integer
    ReproductionType.update_all '`order` = id'
    execute "ALTER TABLE `reproduction_types` CHANGE `order` `order` INT( 11 ) NOT NULL DEFAULT \'0\'"
  end

  def self.down
    remove_column :reproduction_types, :website
    remove_column :reproduction_types, :order
  end
end
