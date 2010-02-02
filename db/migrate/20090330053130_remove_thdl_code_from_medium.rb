class RemoveThdlCodeFromMedium < ActiveRecord::Migration
  def self.up
    remove_column :media, :thdl_code
  end

  def self.down
    add_column :media, :thdl_code, :string
  end
end
