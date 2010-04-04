class CreateShares < ActiveRecord::Migration
  def self.up
    create_table :shares do |t|
      t.integer :link_id
      t.integer :recipient_id
      t.boolean :viewed
      t.boolean :read

      t.timestamps
    end
  end

  def self.down
    drop_table :shares
  end
end
