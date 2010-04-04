class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :link_id
      t.integer :recipient_id
      t.boolean :viewed, :default => false
      t.boolean :read, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
