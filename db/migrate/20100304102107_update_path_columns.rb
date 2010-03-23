class UpdatePathColumns < ActiveRecord::Migration
  
  def self.up
    # For all storage objects: rename "file" to "storage_object_id", add "original_filename", and add non-null requirement
    
    # Games
    change_table :games do |t|
      t.rename  :file, :storage_object_id
      t.string  :original_filename
    end
     
    # rename_column :games, :file,              :storage_object_id
    # change_column :games, :storage_object_id, :null => false
    # add_column    :games, :original_filename, :string
    
    # Thumbnails
    # rename_column :thumbnails,  :path,              :storage_object_id
    # change_column :thumbnails,  :storage_object_id, :null => false
    # add_column    :thumbnails,  :original_filename, :string
    
    change_table :thumbnails do |t|
      t.rename  :path, :storage_object_id
      t.string  :original_filename  # Will be null for generated thumbnails
    end
    
    
    # Users
    remove_column :users, :photo
    # We add a new UserPhoto model in the next migration
  end
  
  def self.down
    change_column :games, :storage_object_id
    rename_column :games, :storage_object_id, :file
    remove_column :games, :original_filename
    
    # Thumbnails
    change_column :thumbnails, :storage_object_id
    rename_column :thumbnails, :storage_object_id, :path
    remove_column :thumbnails, :original_filename
    
    # Users
    add_column :users, :photo, :string
  end
end
