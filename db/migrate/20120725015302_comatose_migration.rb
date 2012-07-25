class ComatosePage < ActiveRecord::Base
  set_table_name 'comatose_pages'
  acts_as_versioned :table_name=>'comatose_page_versions', :if_changed => [:title, :slug, :keywords, :body]
end


class ComatoseMigration < ActiveRecord::Migration

  # Schema for Comatose version 0.7+
  def self.up
    ComatosePage.create_versioned_table
  end

  def self.down
    ComatosePage.drop_versioned_table
  end

end
