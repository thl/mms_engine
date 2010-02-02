class CreateRenderers < ActiveRecord::Migration
  def self.up
    create_table :renderers, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 20, :null => false
      t.column :path, :string, :limit => 100, :null => true
    end
    Renderer.create :title => 'Saxon servlet', :path => '/ndlb/texts?source=base.xml&style=:transformation&xml=:document&clear-stylesheet-cache=yes' 
  end

  def self.down
    drop_table :renderers
  end
end
