class AddUserPhoto < ActiveRecord::Migration
  def self.up
    
    create_table :userPhotos do |t|
      t.references   :user
      
      t.string      :storage_object_id,   :null => false
      t.string      :original_filename,   :null => false
      t.integer     :width,               :null => false
      t.integer     :height,              :null => false
    end
    
    change_table :users do |t|
      t.references :userPhoto
    end
    
  end

  def self.down
    drop_table :userPhotos
  end
end
