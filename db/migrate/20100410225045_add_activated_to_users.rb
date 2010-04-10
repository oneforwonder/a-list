class AddActivatedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activated, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :activated
  end
end
