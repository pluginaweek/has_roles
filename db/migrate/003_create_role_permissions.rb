class CreateRolePermissions < ActiveRecord::Migration
  def self.up
    create_table :role_permissions do |t|
      t.references :role, :permission, :null => false
    end
  end
  
  def self.down
    drop_table :role_permissions
  end
end
