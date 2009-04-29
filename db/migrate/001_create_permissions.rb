class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :controller, :path, :null => false
      t.string :action
    end
  end
  
  def self.down
    drop_table :permissions
  end
end
