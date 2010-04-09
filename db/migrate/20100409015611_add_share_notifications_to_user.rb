class AddShareNotificationsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :share_notifications, :boolean, :default => true
    
    User.all.each do |u|
      u.share_notifications = true
      u.save
    end
    
  end

  def self.down
    remove_column :users, :share_notifications
  end
end
