class CreateLoanTypes < ActiveRecord::Migration
  def self.up
    create_table :loan_types, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.column :title, :string, :limit => 15, :null => false
    end
    add_column :definitions, :loan_type_id, :integer
  end

  def self.down
    drop_table :loan_types
    remove_column :definitions, :loan_type_id
  end
end
