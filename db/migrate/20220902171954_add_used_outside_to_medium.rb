class AddUsedOutsideToMedium < ActiveRecord::Migration
  def change
    add_column :media, :used_outside, :boolean, null: false, default: false
  end
end
