class CreateControllers < ActiveRecord::Migration
  def self.up
    create_table :controllers do |t|
      t.column :path, :string, :null => false
      t.column :description, :text
    end
    add_index :controllers, :path, :unique => true
  end

  def self.down
    drop_table :controllers
  end
end