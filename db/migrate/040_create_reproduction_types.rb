class CreateReproductionTypes < ActiveRecord::Migration
  def self.up
    create_table :reproduction_types, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 30, :null => false
    end
    ReproductionType.create :title => 'No limit'
    ReproductionType.create :title => 'Prohibited'
    ReproductionType.create :title => 'Credit required'
    ReproductionType.create :title => 'Contact copyright holder'
  end

  def self.down
    drop_table :reproduction_types
  end
end
