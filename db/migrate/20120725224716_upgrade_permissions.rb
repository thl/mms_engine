class UpgradePermissions < ActiveRecord::Migration
  def self.up
    AuthenticatedSystem::Permission.where(['title LIKE ?', 'roles/%']).each{|r| r.update_attribute('title', "authenticated_system/#{r.title}")}
  end

  def self.down
    AuthenticatedSystem::Permission.where(['title LIKE ?', 'authenticated_system/roles/%']).each{ |r| r.update_attribute('title', r.title.sub(/authenticated_system\//,'')) }
  end
end
