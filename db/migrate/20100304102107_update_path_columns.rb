class UpdatePathColumns < ActiveRecord::Migration
  
  def self.up
    # For all storage objects: rename "file" to "storage_object_id", and add "original_filename"
    
    # Games
    rename_column :games, :file, :storage_object_id
    change_column :games, :storage_object_id, :text # S3's limit is 1024b
    add_column :games, :original_filename, :string
    
    # Thumbnails
    rename_column :thumbnails, :path, :storage_object_id
    change_column :thumbnails, :storage_object_id, :text # S3's limit is 1024b
    add_column :thumbnails, :original_filename, :string
    
    # Users
    remove_column :users, :photo
    # We'll add a new UserPhoto model in the next migration  
  end
  
  def self.down
    rename_column :games, :storage_object_id, :file
    change_column :games, :file, :string
    remove_column :games, :original_filename
    
    # Thumbnails
    rename_column :thumbnails, :storage_object_id, :path
    change_column :thumbnails, :path, :string
    remove_column :thumbnails, :original_filename
    
    # Users
    add_column :users, :photo, :string
  end
end
