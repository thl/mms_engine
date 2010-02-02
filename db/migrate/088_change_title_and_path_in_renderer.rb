class ChangeTitleAndPathInRenderer < ActiveRecord::Migration
  def self.up
    change_column :renderers, :title, :string, :limit => 50, :null => false
    change_column :renderers, :path, :string, :limit => 200, :null => false
    renderer = Renderer.find(1)
    renderer.title = 'Saxon servlet for documents'
    renderer.path = '/ndlb/texts/SaxonServlet?source=base.xml&style=:transformation&xml=:document&clear-stylesheet-cache=yes'
    renderer.save
    renderer = Renderer.find_by_title('Vanilla saxon servlet') 
    renderer = Renderer.create(:title => 'Vanilla saxon servlet', :path => '/ndlb/texts/VanillaSaxonServlet?source=:document&style=:transformation') if renderer.nil?
    transformation = Transformation.find_by_title('Captions')
    if transformation.nil?
      transformation = Transformation.create(:title => 'Captions', :path => '/transformations/transcript2timedtext.xsl', :renderer_id =>  renderer.id)
    else
      transformation.renderer = renderer
      transformation.save 
    end
    application_setting = ApplicationSetting.find_by_title('captions_transformation_id')
    if application_setting.nil?
      application_setting = ApplicationSetting.create(:title => 'captions_transformation_id', :value => transformation.id)
    else
      application_setting.value = transformation.id
      application_setting.save
    end 
  end

  def self.down
    change_column :renderers, :title, :string, :limit => 20, :null => false
    change_column :renderers, :path, :string, :limit => 100, :null => true
    renderer = Renderer.find(1)
    renderer.title = 'Saxon servlet'
    renderer.path = '/ndlb/texts?source=base.xml&style=:transformation&xml=:document&clear-stylesheet-cache=yes'
    renderer.save
  end
end
