class CreateWorkflows < ActiveRecord::Migration
  def self.up
    create_table :workflows, :options => 'ENGINE=MyISAM, CHARACTER SET=utf8 COLLATE=utf8_general_ci' do |t|
      t.integer :medium_id, :null => false
      t.string :original_filename, :null => false
      t.string :original_medium_id
      t.string :other_id
      t.string :notes
      t.integer :sequence_order
      t.timestamps
    end
    
    Medium.all.each do |medium|
      attachment = medium.attachment
      if attachment.nil?
        say "#{medium.id} has no attachment."
      else
        Workflow.create :medium => medium, :original_filename => attachment.filename
        attachment.filename = medium.id_name
        attachment.save
      end
    end
  end

  def self.down
    Workflow.all.each do |w|
      attachment = w.medium.attachment
      attachment.filename = w.original_filename
      attachment.save
    end
    drop_table :workflows
  end
end
