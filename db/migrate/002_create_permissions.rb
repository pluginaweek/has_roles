class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.column :controller_id,  :integer, :null => false
      t.column :action,         :string
    end
    add_index :permissions, [:controller_id, :action], :unique => true
  end

  def self.down
    drop_table :permissions
  end
end