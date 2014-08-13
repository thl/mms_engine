class CreateThemes < ActiveRecord::Migration
  def self.up
    create_table :registered_themes, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 50, :null => false
      t.column :description, :text
      t.column :namespace, :string, :limit => 10, :null => false 
      t.column :created_on, :date
    end
    theme = RegisteredTheme.create :title => 'Generic', :namespace => 'generic', :description => 'This theme is designed as a generic interface, for usage of the MMC when it is not associated with any organization participating in its development. The open-source license allows for it to be modified to fit the application\'s needs.'
    permission_title = 'registered_themes/index'
    permission = AuthenticatedSystem::Permission.where(title: permission_title).first
    permission = AuthenticatedSystem::Permission.create(:title => permission_title) if permission.nil?
    ApplicationSetting.create :title => 'active_theme_id', :value => theme.id, :permission => permission
    
    RegisteredTheme.create :title => 'e-Bhutan', :namespace => 'e-bhutan', :description => 'This theme is designed for the MMC\'s use within the National Digital Library of Bhutan.'
    RegisteredTheme.create :title => 'THDL', :namespace => 'thdl', :description => 'This theme is designed for the MMC\'s use within the Tibetan and Himalayan Digital Library.'
    RegisteredTheme.create :title => 'Centenary Celebration', :namespace => 'centenary', :description => 'This theme is not a site-wide theme, but only meant for the corresponding collection.'
  end

  def self.down
    drop_table :registered_themes
  end
end
