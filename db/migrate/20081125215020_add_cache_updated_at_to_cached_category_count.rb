class AddCacheUpdatedAtToCachedCategoryCount < ActiveRecord::Migration
  def self.up
    add_column :cached_category_counts, :cache_updated_at, :datetime, :null => false
  end

  def self.down
    remove_column :cached_category_counts, :cache_updated_at
  end
end