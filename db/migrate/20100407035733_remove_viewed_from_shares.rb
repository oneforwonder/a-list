class RemoveViewedFromShares < ActiveRecord::Migration
  def self.up
    remove_column :shares, :viewed
  end

  def self.down
    add_column :shares, :viewed, :boolean, :default => false
  end
end
