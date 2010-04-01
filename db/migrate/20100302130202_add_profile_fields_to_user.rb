class AddProfileFieldsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.text    :about
      t.string  :name
      
      # Facebook connect
      t.string  :facebook_id # UID
      t.string  :facebook_session_key
      
      # Registration
      t.boolean :facebook_new_user,         :null => false,     :default => false   # Show the extended registration process?
      
      # Profile Picture
      t.boolean :use_our_photo,             :null => false,     :default => false   # Or drop down to underlying model (eg Facebook)
      t.string  :photo
    end
    
    # Column Indexing - TODO add/fix these!
    
    add_index :users, :facebook_id
    add_index :users, :facebook_session_key
      
  end

  def self.down
    change_table :users do |t|
      t.remove :about, :name
      t.remove :facebook_id, :facebook_session_key, :facebook_new_user
      t.remove :use_our_photo, :photo
    end
  end
end
