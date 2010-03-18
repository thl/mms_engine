class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.string :title, :null => false
      t.text :description
      t.integer :position, :null => false

      t.timestamps
    end

    Status.reset_column_information
    ['Planned', 'Inputting', 'Proofing', 'Marking up'].each_with_index { |type, index| Status.create(:title => type, :position => index+1) }
    
    add_column :workflows, :status_id, :integer    
  end

  def self.down
    drop_table :statuses
    remove_column :workflows, :status_id
  end
end
