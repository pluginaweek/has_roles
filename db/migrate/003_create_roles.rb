class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.column :name,         :string, :null => false
      t.column :description,  :text
    end
    add_index :roles, :name, :unique => true
  end
  
  def self.down
    drop_table :roles
  end
end
