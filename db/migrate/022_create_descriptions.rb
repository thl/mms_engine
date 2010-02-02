class CreateDescriptions < ActiveRecord::Migration
  def self.up
    create_table :descriptions, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :text, :null => false
      t.column :description_type_id, :integer
      t.column :creator_id, :integer
      t.column :language_id, :integer
      t.column :created_on, :timestamp
      t.column :updated_on, :timestamp
    end
    execute "CREATE UNIQUE INDEX `index_descriptions_on_title_and_type_and_language` ON descriptions (title(100), `description_type_id`, `language_id`)"
  end

  def self.down
    drop_table :descriptions
  end
end
