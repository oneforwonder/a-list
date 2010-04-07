class AddArchivedToShares < ActiveRecord::Migration
  def self.up
    add_column :shares, :archived, :boolean, :default => false
  end

  def self.down
    remove_column :shares, :archived
  end
end
