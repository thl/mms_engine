class CreateApplicationFilters < ActiveRecord::Migration
  def self.up
    create_table :application_filters, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.timestamps
    end
    
    ApplicationFilter.reset_column_information
    vb = ApplicationFilter.create :title => 'Virtual Bhutan Content'    
    thl = ApplicationFilter.create :title => 'THL Content'
    
    add_column :media, :application_filter_id, :integer
    Medium.reset_column_information
    Medium.connection.execute('UPDATE `media` SET application_filter_id = 1 WHERE (id <= 1794)')
    # Medium.update_all("application_filter_id = #{vb.id}", ['id <= ?', 1794])
    Medium.connection.execute('UPDATE `media` SET application_filter_id = 2 WHERE (id > 1794)')
    # Medium.update_all("application_filter_id = #{thl.id}", ['id > ?', 1794])
    change_column :media, :application_filter_id, :integer, :null => false
    
    add_column :countries, :application_filter_id, :integer
    Country.reset_column_information
    Country.update_all("application_filter_id = #{vb.id}", ['id = ?', 1])
    Country.update_all("application_filter_id = #{thl.id}", ['id <> ?', 1])    
    change_column :countries, :application_filter_id, :integer, :null => false
    
    ApplicationSetting.create :title => 'default_filter', :value => vb.id    
    ApplicationSetting.create :title => 'application_filter', :value => vb.id
    ApplicationSetting.create :title => 'country_filter', :value => vb.id
  end

  def self.down
    drop_table :application_filters
    remove_column :media, :application_filter_id
    remove_column :countries, :application_filter_id
    s = ApplicationSetting.where(title: 'default_filter').first
    s.destroy if !s.nil?
    s = ApplicationSetting.where(title: 'application_filter').first
    s.destroy if !s.nil?
    s = ApplicationSetting.where(title: 'country_filter').first
    s.destroy if !s.nil?
  end
end