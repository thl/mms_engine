class CorrectStatusOfMovies < ActiveRecord::Migration
  def self.up
    remove_column :media, :status
    add_column :movies, :status, :integer, :default => 0
  end

  def self.down
    add_column :media, :status, :integer, :default => 0
    remove_column :movies, :status
  end
end
