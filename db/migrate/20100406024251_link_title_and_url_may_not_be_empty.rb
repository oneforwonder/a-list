class LinkTitleAndUrlMayNotBeEmpty < ActiveRecord::Migration
  def self.up
    change_column :links, :title, :string, :null => false
    change_column :links, :url, :string, :null => false
  end

  def self.down
    change_column :links, :title, :string, :null => true
    change_column :links, :url, :string, :null => true
  end
end
