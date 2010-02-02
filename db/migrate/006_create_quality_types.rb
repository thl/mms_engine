class CreateQualityTypes < ActiveRecord::Migration
  def self.up
    create_table :quality_types, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 10, :null => false
    end
    add_index :quality_types, :title, :unique => true
        
    QualityType.create :title => 'Unusable'
    QualityType.create :title => 'Poor'
    QualityType.create :title => 'Average'
    QualityType.create :title => 'Good'
    QualityType.create :title => 'Excellent'
  end

  def self.down
    drop_table :quality_types
  end
end
