class CreateRoleAssignments < ActiveRecord::Migration
  def self.up
    create_table :role_assignments do |t|
      t.references :role, :null => false
      t.references :assignee, :polymorphic => true, :null => false
    end
    add_index :role_assignments, [:role_id, :assignee_id, :assignee_type], :unique => true, :name => 'index_role_assignments_on_role_and_assignee'
  end

  def self.down
    drop_table :role_assignments
  end
end
