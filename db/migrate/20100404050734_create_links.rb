class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :title
      t.text :commentary
      t.integer :submitter_id

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
