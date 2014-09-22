class CreateCumulativeMediaCategoryAssociations < ActiveRecord::Migration
  def self.up
    create_table :cumulative_media_category_associations, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :medium_id, :null => false
      t.integer :category_id, :null => false
      t.timestamps
    end
    add_index :cumulative_media_category_associations, [:category_id, :medium_id], :unique => true, :name => 'by_category_medium'
    CumulativeMediaCategoryAssociation.reset_column_information
    MediaCategoryAssociation.group('category_id').order('category_id').collect(&:category).each do |category|
      medium_ids = MediaCategoryAssociation.where(:category_id => category.id).collect(&:medium_id)
      ([category] + category.ancestors).each { |c| medium_ids.each { |medium_id| CumulativeMediaCategoryAssociation.create(:category => c, :medium_id => medium_id) if CumulativeMediaCategoryAssociation.find_by(category_id: c.id, medium_id: medium_id).nil? } }
    end
  end

  def self.down
    drop_table :cumulative_media_category_associations
  end
end
