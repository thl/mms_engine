class CreateTransformations < ActiveRecord::Migration
  def self.up
    create_table :transformations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :renderer_id, :integer, :null => false
      t.column :title, :string, :limit => 20, :null => false
      t.column :path, :string, :limit => 100, :null => false
    end
    renderer = Renderer.find(1)
    Transformation.create :title => 'Essay', :path => '/transformations/essay.xsl', :renderer => renderer
  end

  def self.down
    drop_table :transformations
  end
end
