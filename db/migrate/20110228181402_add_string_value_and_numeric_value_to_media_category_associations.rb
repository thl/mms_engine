class AddStringValueAndNumericValueToMediaCategoryAssociations < ActiveRecord::Migration
  def self.up
    change_table :media_category_associations do |t|
      t.string :string_value
      t.integer :numeric_value
    end
  end

  def self.down
    change_table :media_category_associations do |t|
      t.remove :string_value
      t.remove :numeric_value
    end
  end
end
