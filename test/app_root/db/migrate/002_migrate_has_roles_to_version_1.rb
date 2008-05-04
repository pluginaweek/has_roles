class MigrateHasRolesToVersion1 < ActiveRecord::Migration
  def self.up
    Rails::Plugin.find(:has_roles).migrate(1)
  end
  
  def self.down
    Rails::Plugin.find(:has_roles).migrate(0)
  end
end
