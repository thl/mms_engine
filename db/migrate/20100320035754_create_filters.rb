class CreateFilters < ActiveRecord::Migration
  def self.up
    create_table :filters, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.timestamps
    end
    
    Filter.create :title => 'THL Content'
    Filter.create :title => 'Virtual Bhutan Content'
    add_column :media, :filter_id, :integer
    # do update on this!!!
    Medium.find(:all, :conditions => ['id <= ?', 1794])
  end

  def self.down
    drop_table :filters
  end
end
