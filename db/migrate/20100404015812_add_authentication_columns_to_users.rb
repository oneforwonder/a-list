class AddAuthenticationColumnsToUsers < ActiveRecord::Migration
  def self.up
    # There are enough changes to justify starting from scratch.
    drop_table :users
    
    create_table :users do |t|
      t.string :first_name
      t.string :last_name

      # The following columns are used by Authlogic.
      t.string :email, :null => false 
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false
      t.datetime :last_request_at
      
      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
