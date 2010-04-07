class RemoveViewedFromShares < ActiveRecord::Migration
  def self.up
    remove_column :users, :viewed
  end

  def self.down
    add_column :users, :viewed, :boolean, :default => false
  end
end
